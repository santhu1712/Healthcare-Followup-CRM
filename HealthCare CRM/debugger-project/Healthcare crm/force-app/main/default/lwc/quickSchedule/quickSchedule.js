import { LightningElement, track } from 'lwc';
import getPatients from '@salesforce/apex/QuickScheduleController.getPatients';
import createAppointment from '@salesforce/apex/QuickScheduleController.createAppointment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class QuickSchedule extends NavigationMixin(LightningElement) {
    @track patientOptions = [];
    selectedPatientId = '';
    appointmentDateTime = '';
    isCreating = false;

    // Load patients when component loads
    connectedCallback() {
        this.loadPatients();
    }

    // Fetch patients from Apex
    loadPatients() {
        getPatients()
            .then(result => {
                this.patientOptions = result.map(p => ({
                    label: p.Name,
                    value: p.Id
                }));
            })
            .catch(error => {
                this.showToast(
                    'Error loading patients',
                    error.body ? error.body.message : error.message,
                    'error'
                );
            });
    }

    handlePatientChange(event) {
        this.selectedPatientId = event.detail.value;
    }

    handleDateChange(event) {
        this.appointmentDateTime = event.target.value; // "yyyy-MM-ddTHH:mm"
    }

    handleCreateAppointment() {
        if (!this.selectedPatientId) {
            this.showToast('Validation', 'Please select a patient', 'warning');
            return;
        }
        if (!this.appointmentDateTime) {
            this.showToast('Validation', 'Please select appointment date & time', 'warning');
            return;
        }

        this.isCreating = true;

        createAppointment({
            patientId: this.selectedPatientId,
            appointmentDateTimeLocal: this.appointmentDateTime
        })
            .then(apptId => {
                this.showToast('Success', 'Appointment created successfully!', 'success');

                // Navigate to new Appointment record
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: apptId,
                        objectApiName: 'Appointment__c',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                this.showToast(
                    'Error creating appointment',
                    error.body ? error.body.message : error.message,
                    'error'
                );
            })
            .finally(() => {
                this.isCreating = false;
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}
