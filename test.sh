#!/bin/bash

# before run this test, you need to install jq tool
# Linux => sudo apt install jq, sudo dnf install jq 
# Mac   => brew install jq

# exporting invoice-app-url
echo "exporting invoice-app-url..."
export INVOICE_APP_URL=$(minikube service invoice-app --url)
echo $INVOICE_APP_URL

echo -e '\n'
# check invoices status
echo "checking current status of invoices..."
curl $INVOICE_APP_URL/invoices

echo -e '\n'
# save invoices in to file
echo "saving invoices in to file..."
curl $INVOICE_APP_URL/invoices > invoice.json

########## invoice 1 ##########
echo -e '\n'
# get first invoice
echo "getting first invoice..."
jq '.[0]' invoice.json

# check the invoice 1 status
invoice1=$(jq '.[0].IsPaid' invoice.json)

# invoice 1 logic
if [ "$invoice1" = "false" ]; then
    echo "Paying invoice 1 bill..."
    curl -d '{"InvoiceId":"I1", "Value":"12.15", "Currency":"EUR"}' -H "Content-Type: application/json" -X POST $INVOICE_APP_URL/invoices/pay
else
    echo "Invoice 1 is already paid!"
fi

########## invoice 2 ##########
echo -e '\n'
# get second invoice
echo "getting second invoice status..."
jq '.[1]' invoice.json

# check the invoice 2 status
invoice2=$(jq '.[1].IsPaid' invoice.json)

# invoice 2 logic
if [ "$invoice2" = "false" ]; then
    echo "Paying invoice 2 bill..."
    curl -d '{"InvoiceId":"I2","Value":10.25,"Currency":"GBP"}' -H "Content-Type: application/json" -X POST $INVOICE_APP_URL/invoices/pay
else
    echo "Invoice 2 is already paid!"
fi

########## invoice 3 ##########
echo -e '\n'
# get third invoice
echo "getting third invoice status..."
jq '.[2]' invoice.json

# check the invoice 3 status
invoice3=$(jq '.[2].IsPaid' invoice.json)

# invoice 3 logic
if [ "$invoice3" = "false" ]; then
    echo "Paying invoice 3 bill..."
    curl -d '{"InvoiceId":"I3","Value":66.13,"Currency":"DKK"}' -H "Content-Type: application/json" -X POST $INVOICE_APP_URL/invoices/pay
else
    echo "Invoice 3 is already paid!"
fi

echo -e '\n'
# remove invoice.json
echo "removing invoice.json..."
rm -f invoice.json

echo -e '\n'
echo "Test complete!"
