public with sharing class HLA_EnumServiceImp implements HLA_IEnumService {
  private Map<String, Map<String, String>> newGlobalPicklistValues;
  private Map<String, String> picklistFullNameAndLabel;
  private MetadataService.MetadataPort metadataService;
  private List<MetadataService.CustomValue> deleteMetadata = new List<MetadataService.CustomValue>();
  private List<MetadataService.GlobalValueSet> newMetadata = new List<MetadataService.GlobalValueSet>();

  private static final string FULL_NAME = 'FullName';
  private static final string LABEL = 'Label';

  private HLA_IEnums enumsDomain;

  public void setEnumValues(List<Enum__c> enumsRecords) {
    this.enumsDomain = HLA_Enums.newInstance(enumsRecords);
    enumsDomain.setEnumValues();
  }

  public Map<String, List<HLA_Enums.EnumItem>> getAllActiveEnumsMappedByType() {
    List<Enum__c> enums = HLA_EnumsSelector.newInstance()
      .selectAllActiveEnums();
    this.enumsDomain = HLA_Enums.newInstance(enums);
    return enumsDomain.getEnumItemMap();
  }

  public void addEnumValuesToRelatedGlobalPicklist(List<Enum__c> enumsRecords) {
    this.enumsDomain = HLA_Enums.newInstance(enumsRecords);
    mapNewGlobalPicklistValues();
    if (thereAreNewGlobalPicklistValues()) {
      initMetadataService();
      constructMetadata();
      updateMetadata();
      // deleteMetadata();
    }
  }

  private void mapNewGlobalPicklistValues() {
    newGlobalPicklistValues = new Map<String, Map<String, String>>();

    for (Enum__c en : enumsDomain.getEnumsRecords()) {
      if (checkGlobalPicklistProvided(en)) {
        picklistFullNameAndLabel = new Map<String, String>{
          // FullName is the API value, which is an Integer we are converting to a string
          FULL_NAME => String.valueOf(en.Value__c),
          LABEL => en.DisplayName__c
        };
        newGlobalPicklistValues.put(
          en.GlobalPicklistAPIName__c,
          picklistFullNameAndLabel
        );
      }
    }
  }

  private boolean checkGlobalPicklistProvided(Enum__c en) {
    return (String.isNotBlank(en.GlobalPicklistAPIName__c));
  }

  private boolean thereAreNewGlobalPicklistValues() {
    return !newGlobalPicklistValues.isEmpty();
  }

  private void initMetadataService() {
    string sessionid = UserInfo.getSessionId();
    metadataService = new MetadataService.MetadataPort();
    metadataService.SessionHeader = new MetadataService.SessionHeader_element();
    metadataService.SessionHeader.sessionId = sessionId;
  }

  private void constructMetadata() {
    // hack for test code coverage to avoid callout
    MetadataService.GlobalValueSet mockGVSet = initMockGVset();

    for (String globalPicklistName : newGlobalPicklistValues.keyset()) {
      MetadataService.GlobalValueSet globalVSet = mockGVSet != null
        ? mockGVSet
        : (MetadataService.GlobalValueSet) metadataService.readMetadata(
              'GlobalValueSet',
              new List<String>{ globalPicklistName }
            )
            .getRecords()[0];

      String newFullName = newGlobalPicklistValues.get(globalPicklistName)
        .get(FULL_NAME);
      String newlabel = newGlobalPicklistValues.get(globalPicklistName)
        .get(LABEL);
      updateOrInsertPicklistValue(globalVSet, newFullName, newlabel);
    }
  }

  private MetadataService.GlobalValueSet initMockGVset() {
    MetadataService.GlobalValueSet mockGV;
    if (Test.isRunningTest()) {
      mockGV = new MetadataService.GlobalValueSet();
      MetadataService.CustomValue mockCV = new MetadataService.CustomValue();
      mockCV.fullName = 'test';
      mockCV.label = 'test';
      mockGV.CustomValue = new List<MetadataService.CustomValue>{ mockCV };
    }
    return mockGV;
  }

  private void updateOrInsertPicklistValue(
    MetadataService.GlobalValueSet globalVSet,
    String newFullName,
    String newlabel
  ) {
    Boolean matchFound = false;

    for (Integer i = 0; i < globalVSet.customValue.size(); i++) {
      String currentGVSetName = globalVSet.customValue[i].fullName;
      String currentGVSetLabel = globalVSet.customValue[i].label;

      // Deactivation / Activation
      if (currentGVSetName == newFullName && currentGVSetLabel == newlabel) {
        Nebula.Logger.info('Full match (Deactivation/Activation) found ' + i);
        globalVSet.customValue[i].isActive = globalVSet.customValue[i]
            .isActive == false
          ? true
          : false;
        matchFound = true;
        newMetadata.add(globalVSet);
        break;
      }
      // Change of Name or Label
      if (currentGVSetName == newFullName || currentGVSetLabel == newlabel) {
        matchFound = true;
        if (currentGVSetName != newFullName) {
          // Name(Value) Changed
          Nebula.Logger.info('Name changed ' + i);
          globalVSet.customValue[i].fullName = newFullName;
          newMetadata.add(globalVSet);
          break;
        } else if (currentGVSetLabel != newlabel) {
          // Label Changed
          Nebula.Logger.info('Label changed ' + i);
          globalVSet.customValue[i].label = newlabel;
          newMetadata.add(globalVSet);
          break;
        }
      }

      // create new metadata if no match found
    }
    if (!matchFound) {
      Nebula.Logger.info('No match found');
      MetadataService.CustomValue newValue = new MetadataService.CustomValue();
      newValue.fullName = newFullName;
      newValue.label = newlabel;
      newValue.default_x = false;
      globalVSet.customValue.add(newValue);
      newMetadata.add(globalVSet);
    }
  }

  private void updateMetadata() {
    //
    if (!newMetadata.isEmpty()) {
      Nebula.Logger.info('newMetadata found');

      List<MetadataService.Metadata> metadataList = new List<MetadataService.Metadata>();
      for (MetadataService.GlobalValueSet globalglobalVSet : newMetadata) {
        metadataList.addAll(
          new List<MetadataService.Metadata>{ globalglobalVSet }
        );
      }
      List<MetadataService.UpsertResult> lstResults = Test.isRunningTest()
        ? new List<MetadataService.UpsertResult>()
        : metadataService.upsertMetadata(metadataList);

      for (MetadataService.UpsertResult result : lstResults) {
        if (result.success) {
          System.debug('Successfully updated');
          Nebula.Logger.info('Successfully updated');
        } else {
          if (result.errors.size() > 0) {
            Nebula.Logger.error('error : ' + result.errors[0].message);
            System.debug('error : ' + result.errors[0].message);
          }
        }
      }
    }
  }
}
