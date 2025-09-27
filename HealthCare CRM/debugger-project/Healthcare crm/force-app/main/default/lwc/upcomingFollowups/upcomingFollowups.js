import { LightningElement, api, track, wire } from 'lwc';
import getUpcomingFollowUps from '@salesforce/apex/UpcomingFollowupsController.getUpcomingFollowUps';
import createFollowUp from '@salesforce/apex/UpcomingFollowupsController.createFollowUp';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

// replace these if your object/field names differ:
const PATIENT_NAME_FIELD = 'Patient__c.Name';

export default class UpcomingFollowups extends NavigationMixin(LightningElement) {
  @api recordId; // when placed on Patient record page this is the patient Id
  @track followUps = [];
  patientName;

  connectedCallback() {
    // initial load via imperative call
    this.loadFollowUps();
  }

  // wire adapter to get patient name (example of wire adapter use)
  @wire(getRecord, { recordId: '$recordId', fields: [PATIENT_NAME_FIELD] })
  wiredPatient({ error, data }) {
    if (data) {
      // guard: some orgs return different field token; adapt if needed
      this.patientName = data.fields ? data.fields.Name.value : '';
    }
  }

  loadFollowUps() {
    if (!this.recordId) return;
    getUpcomingFollowUps({ patientId: this.recordId })
      .then(result => {
        this.followUps = result;
      })
      .catch(error => {
        // handle error (console + optional UI toast)
        // eslint-disable-next-line no-console
        console.error('Error loading follow-ups', error);
      });
  }

  handleCreateFollowUp() {
    if (!this.recordId) return;
    // create follow-up for +7 days (format yyyy-mm-dd)
    const d = new Date();
    d.setDate(d.getDate() + 7);
    const isoDate = d.toISOString().split('T')[0]; // "YYYY-MM-DD"
    createFollowUp({ patientId: this.recordId, followUpDateStr: isoDate })
      .then((newId) => {
        // refresh list
        this.loadFollowUps();
        // dispatch an event so parent or other components can react
        this.dispatchEvent(new CustomEvent('refresh'));
      })
      .catch(error => {
        // eslint-disable-next-line no-console
        console.error('Error creating follow-up', error);
      });
  }

  navigateToFollowUp(event) {
    const recId = event.currentTarget.dataset.id;
    if (!recId) return;
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: recId,
        objectApiName: 'FollowUp_Schedule__c',
        actionName: 'view'
      }
    });
  }
}
