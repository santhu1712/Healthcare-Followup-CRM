trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    // Step 1: Collect Opportunity Ids that are (newly) Closed Won
    Set<Id> closedWonOppIds = new Set<Id>();

    if (Trigger.isInsert) {
        for (Opportunity opp : Trigger.new) {
            if (opp.StageName == 'Closed Won') {
                closedWonOppIds.add(opp.Id);
            }
        }
    } else if (Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
            // Only when it CHANGES to Closed Won (prevents duplicates on edits)
            if (opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {
                closedWonOppIds.add(opp.Id);
            }
        }
    }

    if (closedWonOppIds.isEmpty()) return;

    // Step 2: Find which of those Opps already have our follow-up task
    Map<Id, Boolean> oppHasTask = new Map<Id, Boolean>();
    for (Id idVal : closedWonOppIds) oppHasTask.put(idVal, false);

    for (Task t : [
        SELECT Id, WhatId
        FROM Task
        WHERE Subject = 'Follow Up Test Task'
          AND WhatId IN :closedWonOppIds
    ]) {
        oppHasTask.put(t.WhatId, true);
    }

    // Step 3: Build tasks ONLY for Opps that don’t already have one
    List<Task> toInsert = new List<Task>();
    for (Id oppId : closedWonOppIds) {
        if (!oppHasTask.get(oppId)) {
            toInsert.add(new Task(
                Subject = 'Follow Up Test Task',
                WhatId  = oppId
            ));
        }
    }

    // Step 4: Single bulk DML
    if (!toInsert.isEmpty()) {
        insert toInsert;
    }
}