import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountTable extends LightningElement {

    columns = [
        { label: 'Account Name', fieldName: 'Name', type: 'text' },
        { label: 'Industry', fieldName: 'Industry', type: 'text' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' }
    ];

    accounts;

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error('Error:', error);
        }
    }
}