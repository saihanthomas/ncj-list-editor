// Copyright 2020 salesforce.com, inc
// All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

/**
 * CommList_EditRL_LookupFieldCC
 * @version 1.0
 * @Description: Handling lookup fields handling
 */
public with sharing class CommList_EditRL_LookupFieldCC {
  /**
   * Aura enabled method to get the name of the initial record to load
   * @param  Id recordId, String[] objectsToSearch
   * @return ResultDataLookup
   */
  @AuraEnabled(cacheable=true)
  public static ResultDataLookup getRecordName(
    String recordId,
    String[] objectsToSearch
  ) {
    if (String.isBlank(recordId)) {
      return new ResultDataLookup(null, null, null, null);
    }

    try {
      // Retrieving data
      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
      for (String objectName : objectsToSearch) {
        String sanitizeName = String.escapeSingleQuotes(objectName);
        Schema.SObjectType leadSchema = schemaMap.get(sanitizeName);
        if (leadSchema == null) {
          return new ResultDataLookup(null, null, null, null);
        }
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe()
          .fields.getMap();
        String nameField;
        if (fieldMap.get('Name') != null) {
          nameField = 'Name';
        } else if (fieldMap.get('Subject') != null) {
          nameField = 'Subject, CaseNumber';
        } else if (fieldMap.get('DeveloperName') != null) {
          nameField = 'DeveloperName';
        } else {
          return new ResultDataLookup(null, null, null, null);
        }

        // Creating query data
        String myQuery =
          'SELECT Id, ' +
          nameField +
          ' FROM ' +
          sanitizeName +
          ' WHERE Id = \'' +
          String.escapeSingleQuotes(recordId) +
          '\'';

        //System.debug('query: ' + myQuery);
        List<sObject> results = Database.query(myQuery);

        if (results.size() > 0) {
          String strName = results[0].getSobjectType().getDescribe().getName();
          ResultDataLookup dataResult;
          if (fieldMap.get('Subject') != null) {
            if (String.isNotBlank((String) results[0].get('Subject'))) {
              dataResult = new ResultDataLookup(
                strName,
                (String) results[0].get('Subject'),
                results[0].Id,
                null
              );
            } else {
              dataResult = new ResultDataLookup(
                strName,
                (String) results[0].get('CaseNumber'),
                results[0].Id,
                null
              );
            }
          } else {
            dataResult = new ResultDataLookup(
              strName,
              (String) results[0].get(nameField),
              results[0].Id,
              null
            );
          }
          return dataResult;
        }
      }
    } catch (Exception ex) {
      return new ResultDataLookup(null, 'Invalid record id', null, null);
    }

    return new ResultDataLookup(null, 'Invalid record id', null, null);
  }

  /**
   * Aura enabled method to search a specified SObject for a specific string
   * @param  Id recordId, String[] objectsToSearch
   * @return ResultDataLookup[]
   */
  @AuraEnabled(cacheable=true)
  public static ResultDataLookup[] lookup(
    String searchString,
    String[] objectsToSearch
  ) {
    // Sanitze the input
    String sanitizedSearchString = String.escapeSingleQuotes(searchString);
    String strFieldReturn = '';
    for (String objectName : objectsToSearch) {
      String sanitizeName = String.escapeSingleQuotes(objectName);
      if (sanitizeName == 'Case') {
        strFieldReturn += sanitizeName + '(id,Subject,CaseNumber), ';
      } else {
        strFieldReturn += sanitizeName + '(id,name), ';
      }
    }
    if (strFieldReturn.endsWith(', ')) {
      strFieldReturn = strFieldReturn.removeEnd(', ') + ' ';
    }

    List<ResultDataLookup> dataresults = new List<ResultDataLookup>();

    // Build our SOSL query
    String searchQuery =
      'FIND \'' +
      sanitizedSearchString +
      '*\' IN ALL FIELDS RETURNING ' +
      strFieldReturn +
      ' Limit 50';

    // Execute the Query
    List<List<SObject>> lstDataSearch = search.query(searchQuery);

    // Create a list of matches to return
    for (List<Sobject> lstTarget : lstDataSearch) {
      for (SObject targetObject : lstTarget) {
        String objectName = targetObject.getSobjectType()
          .getDescribe()
          .getName();
        if (objectName == 'Case') {
          if (String.isNotBlank((String) targetObject.get('Subject'))) {
            dataresults.add(
              new ResultDataLookup(
                objectName,
                (String) targetObject.get('Subject'),
                targetObject.Id,
                (String) targetObject.get('CaseNumber')
              )
            );
          } else {
            dataresults.add(
              new ResultDataLookup(
                objectName,
                '',
                targetObject.Id,
                (String) targetObject.get('CaseNumber')
              )
            );
          }
        } else {
          dataresults.add(
            new ResultDataLookup(
              objectName,
              (String) targetObject.get('Name'),
              targetObject.Id,
              null
            )
          );
        }
      }
    }

    return dataresults;
  }

  /**
   * Inner class to wrap up an SObject Label and its Id
   */
  public class ResultDataLookup {
    @AuraEnabled
    public String recLabel { get; set; }
    @AuraEnabled
    public Id recId { get; set; }
    @AuraEnabled
    public String objectIcon { get; set; }
    @AuraEnabled
    public String objectName { get; set; }
    @AuraEnabled
    public String subRecLabel { get; set; }

    public ResultDataLookup(
      String objectName,
      String recLabel,
      Id recId,
      String subRecLabel
    ) {
      this.objectName = objectName;
      if (String.isNotBlank(objectName))
        this.objectIcon = objectName.endsWith('__c')
          ? 'standard:custom_notification'
          : 'standard:' + objectName.toLowerCase();
      this.recLabel = recLabel;
      this.recId = recId;
      this.subRecLabel = subRecLabel;
    }
  }
}
