#!/usr/bin/env bash
# rightsizing-csv.sh — Generate a rightsizing CSV for all running instances
 
echo "InstanceId,Name,Type,vCPUs,AvgCPU%,Status"
 
REGION=$(aws configure get region)
END_TIME=$(date -u '+%Y-%m-%dT%H:%M:%S')
START_TIME=$(date -u -d '7 days ago' '+%Y-%m-%dT%H:%M:%S')
 
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].[InstanceId,InstanceType,Tags[?Key==`Name`].Value|[0]]' \
  --output text | while read -r ID TYPE NAME; do
 
  VCPUS=$(aws ec2 describe-instance-types --instance-types "$TYPE" \
    --query 'InstanceTypes[0].VCpuInfo.DefaultVCpus' --output text)
 
  AVG_CPU=$(aws cloudwatch get-metric-statistics \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value="$ID" \
    --start-time "$START_TIME" --end-time "$END_TIME" \
    --period 86400 --statistics Average \
    --query 'Datapoints[].Average | [0]' --output text 2>/dev/null)
 
  if [[ "$AVG_CPU" == "None" || -z "$AVG_CPU" ]]; then
    STATUS="NO_DATA"
    AVG_CPU="N/A"
  elif (( $(echo "$AVG_CPU < 10" | bc -l) )); then
    STATUS="OVERSIZED"
  elif (( $(echo "$AVG_CPU > 80" | bc -l) )); then
    STATUS="UNDERSIZED"
  else
    STATUS="RIGHT_SIZED"
  fi
 
  echo "$ID,${NAME:-unnamed},$TYPE,$VCPUS,$AVG_CPU,$STATUS"
done