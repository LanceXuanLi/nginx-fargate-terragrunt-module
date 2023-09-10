# Terraform Nginx Fargate Module

This Terraform module deploys a public Nginx server using AWS Fargate, AWS Application Load Balancer, and AWS WAF with specified rules.

## Prerequisites

Before using this module, ensure you have the following:

- Terraform installed (version >= 0.12.0)
- AWS credentials configured
- Terragrunt (optional, for bonus points)
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
- [x] Bonus: Implement auto scaling (not yet implemented)

## Bonus Points

- **Terragrunt**: This module is configured to be used with Terragrunt for seamless deployment across multiple environments and regions.

- **Mock Attack Behavior**: Mock attack behavior has been implemented and screenshots are available [here](/screenshots/mock_attack.png).

- **Auto Scaling**: TargetTrackingScaling strategy, scale up when cpu > 80%, memory > 60%

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
  - logs of alb
- waf
  - one rate based rule with 300 threshold in 5 minutes 
    - The reason is: **"AWS WAF checks the rate of requests every 30 seconds, and counts requests for the prior 5 minutes each time. Because of this, it's possible for an aggregation instance to have requests coming in at too high a rate for up to 30 seconds before AWS WAF detects and rate limits the requests for the instance. Similarly. the request rate can be below the limit for up to 30 seconds before AWS WAF detects the decrease and discontinues rate limiting for the instance."** 
    - Referenced from  https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-rate-based-request-limiting.html
  - aws managed rules for OWASP top 10 attacks
    - AWSManagedRulesCommonRuleSet
    - The Core rule set (CRS) rule group contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities, including some of the high risk and commonly occurring vulnerabilities described in OWASP publications such as OWASP Top 10. Consider using this rule group for any AWS WAF use case.
    - Referenced from https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html
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