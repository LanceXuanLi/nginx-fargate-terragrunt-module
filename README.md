# Terragrunt Nginx Fargate Module

This Terragrunt module deploys a public Nginx server using AWS Fargate, AWS Application Load Balancer, and AWS WAF with specified rules.

## Prerequisites

Before using this module, ensure you have the following:

- Terraform installed (version >= 0.12.0)
- AWS credentials configured
- Terragrunt
- aws provider 5.16.1 (latest)

## Task List Completion

- [x] Write Terraform module to host public Nginx server on AWS Fargate
- [x] Use AWS Application Load Balancer
- [x] Implement AWS WAF with specified rules
    - [x] Rate limit rule (blocking IPs with > 60 requests in a minute)
    - [x] OWASP top 10 attack rules
- [x] Use Capacity Provider with 1:1 ratio of Fargate to Fargate Spot
- [x] Deploy in ap-southeast-2 and eu-west-1 regions
- [x] Bonus: Use Terragrunt for deployment
- [x] Bonus: Mock attack behavior and provide screenshot
- [x] Bonus: Implement auto scaling 





## Bonus Points

- **Terragrunt**: This module is configured to be used with Terragrunt for seamless deployment across multiple environments and regions.

- **Mock Attack Behavior**: Mock attack behavior has been implemented and screenshots are available [here](/screenshots/mock_attack.png).

https://github.com/LanceXuanLi/nginx-fargate-terraform-module/assets/15911068/4c0020b4-a75c-4aac-ad44-cfc35e73c277

`oha -n 2000 --burst-delay 2s --burst-rate 30 http://sapia-qa-1344606689.ap-southeast-2.elb.amazonaws.com` means that I sent 2000 HTTP requests to the specified URL, with bursts of 30 requests per second, and a 2-second delay between bursts.\
The rate-based statement currently stops processing requests after 41 seconds, in accordance with AWS documentation, which specifies that WAF evaluates rates every 30 seconds. I've already reported this issue to AWS support, and any updates they provide will be posted here.\
\
*"AWS WAF checks the rate of requests every 30 seconds, and counts requests for the prior 5 minutes each time. Because of this, it's possible for an aggregation instance to have requests coming in at too high a rate for up to 30 seconds before AWS WAF detects and rate limits the requests for the instance. Similarly. the request rate can be below the limit for up to 30 seconds before AWS WAF detects the decrease and discontinues rate limiting for the instance."*  Referenced from  https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based-request-limiting.html

- **Auto Scaling**: TargetTrackingScaling strategy, scale up when cpu > 80%, memory > 60%

## Resource Module (terraform)
- Link: https://github.com/LanceXuanLi/nginx-fargate-resource-module
- README: https://github.com/LanceXuanLi/nginx-fargate-resource-module/blob/master/README.md

## Structure
![](Nginx%20Diagram.drawio.png)

## Details
- vpc 
  - x public subnets with x private subnets in x zones
  - 2 security groups, one for alb, another for ecs
  - NGW: Due to the limited availability of 5 EIPs per account, I've placed all NAT gateways in one subnet to conserve EIPs. While multiple gateways would enhance robustness, the scarcity of EIPs prevents their creation.
  - IGW: one for vpc
  - Route table: two tables, 
    - one for public subnets to igw
    - one for private subnets outbound traffic to ngw
- s3
  - logs for alb
- waf
  - one rate based rule with 300 threshold in 5 minutes
    - *The maximum number of requests allowed in a five-minute period that satisfy the criteria you provide before limiting the requests using the rule action setting. The minimum rate that you can set is 100.* Referenced from https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based-high-level-settings.html
    - "if a single IP makes more than 60 requests in a minute, it should be blocked" means if a single IP makes more than 300 requests in 5 minutes, it should be blocked.
   
  - aws managed rules for OWASP top 10 attacks
    - AWSManagedRulesCommonRuleSet
    - *The Core rule set (CRS) rule group contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities, including some of the high risk and commonly occurring vulnerabilities described in OWASP publications such as OWASP Top 10. Consider using this rule group for any AWS WAF use case.* Referenced from https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html
- alb
  - subnets: x public subnets
  - target_group: attach to ecs service
- ecs
  - capacity-providers
    - "FARGATE", "FARGATE_SPOT"
  - task_definition 
    - nginx:latest from docker.io
  - service
    - capacity_provider_strategy (FARGATE: base 1, weight 1; FARGATE_SPOT: weight 1 )
- auto-scaling
  - TargetTrackingScaling
    - scale up when cpu > 80%
    - scale up when memory > 60%

## Authors

- Lance Li <lance.nanxuanli@gmail.com>

## License

This project is licensed under the [MIT License](LICENSE).
