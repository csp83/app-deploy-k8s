#!/bin/bash

# before run this test, you need to install jq tool
# Linux => sudo apt install jq, sudo dnf install jq 
# Mac   => brew install jq

# if you want shell output (test result) to file run this command -> ./test.sh 2>&1 | tee test-result.txt

# exporting invoice-app-url
echo "exporting invoice-app-url..."
export INVOICE_APP_URL=$(minikube service invoice-app --url)
echo $INVOICE_APP_URL
echo -e '\n'

# save invoices in to file
echo "saving invoices in to file..."
curl $INVOICE_APP_URL/invoices > invoice.json
echo -e '\n'

# check invoices status
printf "Before Paid - Current status of invoices...\n"
curl $INVOICE_APP_URL/invoices
echo -e '\n'


# Get the total number of invoices
size=$(jq length invoice.json)
printf "Total number of invoices - %s" "$size"
echo -e '\n'


# Pay the invoice for all the unpaid ones
echo "Paying the invoice for all the unpaid ones..."
for (( c=0; c<size; c++ ))
do
   result=$( echo $c+1 | bc )

   echo -e '\n'
   printf "### Invoice - %s" "$result details"
   printf "\nInvoiceId =  %s" "$(jq '.['$c'].InvoiceId' invoice.json)"
   printf "\nValue =  %s" "$(jq '.['$c'].Value' invoice.json)"
   printf "\nCurrency =  %s" "$(jq '.['$c'].Currency' invoice.json)"
   IsPaid=$(jq '.['$c'].IsPaid' invoice.json)

   if [ $c = 1 ]; then
      IsPaid=false
      printf "\nIsPaid =  %s" "$IsPaid"
   else
      printf "\nIsPaid =  %s" "$IsPaid"
   fi

   echo -e '\n'

   if [ "$IsPaid" = "false" ]; then
       echo "Paying Invoice" $result "bill..."
       curl -d '{"InvoiceId":"'+$InvoiceId+'", "Value":"'+Value+'", "Currency":"'+Currency+'"}' -H "Content-Type: application/json" -X POST $INVOICE_APP_URL/invoices/pay
   else
       echo "Invoice "$result" is already paid!"
   fi
done

echo -e '\n'
# check invoices status
printf "After Paid - Current status of invoices...\n"
curl $INVOICE_APP_URL/invoices

echo -e '\n'
echo "Test complete!"
