#!/bin/bash
curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/resourceId?api-version=2019-08-01&format=text"
echo
