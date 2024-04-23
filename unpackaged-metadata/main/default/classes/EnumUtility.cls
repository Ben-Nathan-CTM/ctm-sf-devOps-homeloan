public class EnumUtility {
  @future
  public static void createGlobalPicklistsFromEnumStaticResource() {
    StaticResource defaultResource = [
      SELECT s.Body
      FROM StaticResource s
      WHERE s.Name LIKE 'enum'
    ];
    blob tempB = defaultResource.Body;
    String contentFile = tempB.toString();
    String[] filelines = contentFile.split('\r\n');

    String mLabel = '';

    map<String, String> fileMap = new Map<String, String>();

    for (Integer i = 0; i < filelines.size(); i++) {
      String fileString = '';
      String line = filelines[i];
      String[] parts = line.split(',');

      String fullname = parts[1];
      String label = parts[0];
      String globalPicklistName = parts[2];
      system.debug(fullname);
      system.debug(label);
      system.debug(globalPicklistName);

      fileString +=
        '<customValue>' +
        '<fullName>' +
        fullname +
        '</fullName>' +
        '<default>false</default>' +
        '<label>' +
        label +
        '</label>' +
        '</customValue>';

      if (fileMap.containsKey(globalPicklistName)) {
        String tempString = fileMap.get(globalPicklistName);
        tempString += fileString;
        fileMap.put(globalPicklistName, tempString);
      } else {
        String templateStart =
          '<?xml version="1.0" encoding="UTF-8"?>' +
          '<GlobalValueSet xmlns="http://soap.sforce.com/2006/04/metadata">' +
          '<masterLabel>' +
          globalPicklistName +
          '</masterLabel>' +
          '<sorted>false</sorted>';
        fileMap.put(globalPicklistName, templateStart + fileString);
      }
    }

    List<ContentVersion> cvList = new List<ContentVersion>();

    for (String title : fileMap.keySet()) {
      String data = fileMap.get(title) + '</GlobalValueSet>';
      ContentVersion cv = new ContentVersion();
      cv.ContentLocation = 'S'; //denotes it resides on Salesforce
      cv.Title = title + '.globalValueSet-meta.xml'; //title of the file
      cv.PathOnClient = title + '.globalValueSet-meta.xml'; // full path within Salesforce this can just be the name of file to be in the library
      cv.VersionData = Blob.valueOf(data); //file data
      cvList.add(cv);
    }
    insert cvList;
  }
}
