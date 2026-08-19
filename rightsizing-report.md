# EC2 Rightsizing Report
 
## Analysis Period
- **Date:** 08/19/2026
- **Duration:** 30 minutes of monitoring
- **Method:** CloudWatch metrics + synthetic load testing
 
## Instance Analysis
 
| Instance Name | Current Type | vCPUs | RAM (GB) | Avg CPU % | Avg Mem % | Recommended Type | Monthly Savings |
|---------------|-------------|-------|----------|-----------|-----------|-----------------|----------------|
| web-server | t3.medium | 2 | 4 | 65% | 55% | t3.medium (keep) | $0.00 |
| api-server | t3.large | 2 | 8 | 2% | 12% | t3.small | $26.28 |
| data-processor | m5.xlarge | 4 | 16 | 2% | 8% | t3.medium | $107.31 |
 
## Pricing Reference (us-east-1, On-Demand)
- t3.small: $0.0208/hr → ~$15.17/mo
- t3.medium: $0.0416/hr → ~$30.37/mo
- t3.large: $0.0832/hr → ~$60.74/mo
- m5.xlarge: $0.192/hr → ~$140.16/mo
 
## Total Projected Monthly Savings: $133.59
 
## Recommendations
1. **web-server (t3.medium):** Properly sized — CPU peaks at 65%. Keep current type.
2. **api-server (t3.large):** Severely over-provisioned. Downsize to t3.small.
3. **data-processor (m5.xlarge):** Severely over-provisioned. Downsize to t3.medium.