public with sharing class HLA_ScreenFlow_AddFiancials_GetId_Invoc {
  @InvocableMethod(label='Get Correct Record Id Formats' description='Returns record Id After splitting String recieved from ScreenFlow Multipicklist Selection')
  public static List<list<string>> parseRecorIds(List<string> selectedApplicantId) {

      if(!(selectedApplicantId.isEmpty())){

          List<String> lstnew = selectedApplicantId[0].split(';');

          list<list<string>> finalLst = new list<list<string>>();

          finalLst.add(lstnew);

          return finalLst;

      }

      else return null;

   }
}