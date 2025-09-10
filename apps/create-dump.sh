#!/bin/bash

echo "Config:"
if [ ! -z "$bucketName" ] ; then
    echo "  bucketName: $bucketName"
 else
    echo "missing bucketName"
    exit 1
fi
echo "  bucketDir: $bucketDir"

if [ ! -z "$eiFeedsAircraftMessageDbConnectionString" ] ; then
    echo "  eiFeedsAircraftMessageDbConnectionString: ***"
 else
    echo "missing eiFeedsAircraftMessageDbConnectionString"
    exit 1
fi
if [ ! -z "$eiFeedsFlightLegDbConnectionString" ] ; then
    echo "  eiFeedsFlightLegDbConnectionString: ***"
 else
    echo "missing eiFeedsFlightLegDbConnectionString"
    exit 1
fi
if [ ! -z "$eiFeedsFlightScheduleDbConnectionString" ] ; then
    echo "  eiFeedsFlightScheduleDbConnectionString: ***"
 else
    echo "missing eiFeedsFlightScheduleDbConnectionString"
    exit 1
fi
if [ ! -z "$eiFeedsInventoryDbConnectionString" ] ; then
    echo "  eiFeedsInventoryDbConnectionString: ***"
 else
    echo "missing eiFeedsInventoryDbConnectionString"
    exit 1
fi
if [ ! -z "$eiFeedsPdrDbConnectionString" ] ; then
    echo "  eiFeedsPdrDbConnectionString: ***"
 else
    echo "missing eiFeedsPdrDbConnectionString"
    exit 1
fi
if [ ! -z "$eiFeedsPdrPaxBoardingInfoDbConnectionString" ] ; then
    echo "  eiFeedsPdrPaxBoardingInfoDbConnectionString: ***"
 else
    echo "missing eiFeedsPdrPaxBoardingInfoDbConnectionString"
    exit 1
fi
if [ ! -z "$eiFeedsPnrDbConnectionString" ] ; then
    echo "  eiFeedsPnrDbConnectionString: ***"
 else
    echo "missing eiFeedsPnrDbConnectionString"
    exit 1
fi
if [ ! -z "$flightDbConnectionString" ] ; then
    echo "  flightDbConnectionString: ***"
 else
    echo "missing flightDbConnectionString"
    exit 1
fi
if [ ! -z "$flightLegRecordDbConnectionString" ] ; then
    echo "  flightLegRecordDbConnectionString: ***"
 else
    echo "missing flightLegRecordDbConnectionString"
    exit 1
fi
if [ ! -z "$pnrDbConnectionString" ] ; then
    echo "  pnrDbConnectionString: ***"
 else
    echo "missing pnrDbConnectionString"
    exit 1
fi

bucketDestinationPath="s3://$bucketName"
if [ ! -z "$bucketDir" ] ; then
    bucketDestinationPath="$bucketDestinationPath/$bucketDir"
fi


dumpDir="/app/mongodbDump"
mkdir $dumpDir

function dumpDb() {
    
    echo "Dumping $2"
    mongodump --uri "$1" --gzip --archive="$dumpDir/$2.gz"
    echo "Dumping $2 completed"
}

function copyToS3() {
    
    echo "copying $1.gz to s3"
    aws s3 cp "$dumpDir/$1.gz" "$bucketDestinationPath/$1.gz"
    echo "copying $1.gz to s3 completed"
}

echo "dumping dbs"
dumpDb "$eiFeedsAircraftMessageDbConnectionString" "EIFeedsAircraftMessage"
dumpDb "$eiFeedsFlightScheduleDbConnectionString" "EIFeedsFlightSchedule"
dumpDb "$eiFeedsInventoryDbConnectionString" "EIFeedsInventory"
dumpDb "$eiFeedsPdrDbConnectionString" "EIFeedsPdr"
dumpDb "$eiFeedsPdrPaxBoardingInfoDbConnectionString" "EIFeedsPdrPaxBoardingInfo"
dumpDb "$eiFeedsPnrDbConnectionString" "EIFeedsPnr"
dumpDb "$flightDbConnectionString" "Flight"
dumpDb "$flightLegRecordDbConnectionString" "FlightLegRecord"
dumpDb "$pnrDbConnectionString" "Pnr"
echo "Dumping EIFeedsFlightLeg"
mongodump --uri $eiFeedsFlightLegDbConnectionString --excludeCollection FlightLegChangeSet --gzip --archive="$dumpDir/EIFeedsFlightLeg.gz"
echo "Dumping $db completed"




echo "copying Files to s3"
copyToS3 "EIFeedsAircraftMessage"
copyToS3 "EIFeedsFlightLeg"
copyToS3 "EIFeedsFlightSchedule"
copyToS3 "EIFeedsInventory"
copyToS3 "EIFeedsPdr"
copyToS3 "EIFeedsPdrPaxBoardingInfo"
copyToS3 "EIFeedsPnr"
copyToS3 "Flight"
copyToS3 "FlightLegRecord"
copyToS3 "Pnr"


