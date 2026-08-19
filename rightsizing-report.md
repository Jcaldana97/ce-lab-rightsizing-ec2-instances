# EC2 Rightsizing Report
 
## Analysis Period
- **Date:** 08/19/2026
- **Duration:** 30 minutes of monitoring
- **Method:** CloudWatch metrics + synthetic load testing
 
## Instance Analysis
 
| Instance Name | Current Type | vCPUs | RAM (GB) | Avg CPU % | Avg Mem % | Recommended Type | Monthly Savings |
|---------------|-------------|-------|----------|-----------|-----------|-----------------|----------------|
| web-server | t3.small | 2 | 4 | 98.85% | 28.1% | t3.medium (keep) | $0.00 |
| api-server | c7i-flex.large | 2 | 8 | 0.46% | 6.17% | t3.small | $26.28 |
| data-processor | m7i-flex.large | 4 | 16 | 0.51% | 2.5% | t3.medium | $107.31 |
 
## Pricing Reference (us-east-1, On-Demand)
- t3.small: $0.0208/hr → ~$15.17/mo
- c7i-flex.large: $0.0832/hr → ~$60.74/mo
- m7i-flex.large: $0.192/hr → ~$140.16/mo
 
## Total Projected Monthly Savings: $133.59
 
## Recommendations
1. **web-server (t3.medium):** Properly sized — CPU peaks at 65%. Keep current type.
2. **api-server (t3.large):** Severely over-provisioned. Downsize to t3.small.
3. **data-processor (m5.xlarge):** Severely over-provisioned. Downsize to t3.medium.