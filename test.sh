#!/bin/bash

# check invoices status
curl $INVOICE_APP_URL/invoices

# pay
curl -d '{"InvoiceId":"I1", "Value":"12.15", "Currency":"EUR"}' -H "Content-Type: application/json" -X POST $INVOICE_APP_URL/invoices/pay

# check invoices status
curl $INVOICE_APP_URL/invoices
