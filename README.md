# sparkle-pack-aws-my-load-balancers
SparklePack to auto-detect load balancers within a certain VPC.  The VPC must
have an "Environment" tag, where its value probably matches a Chef environment
or something equivalent.

Support ELBS only; ALBs will come when I start using them or submit a pull
request.

h/t to [techshell](https://github.com/techshell) for this approach.

### Tags

- In order to use this Sparkle Pack, you must assign a `Purpose` tag
to your ELBs.

### Environment variables

The following environment variables must be set in order to use this Sparkle
Pack:

- AWS_REGION
- AWS_DEFAULT_REGION (being deprecated?)
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- environment


## Use Cases
This SparklePack adds a registry entry that uses the AWS SDK to detect load
balancers within your VPC (based on `ENV['AWS_REGION']` and `ENV['environment']`)
and returns either an array of load balancer names, or a single load balancer
whose `Purpose` tag matches the specified filter.

## Usage
Add the pack to your Gemfile and .sfn:

Gemfile:
```ruby
source 'https://rubygems.org'

gem 'sfn'
gem 'sparkle-pack-aws-my-load-balancers'
```

.sfn:
```ruby
Configuration.new do
  sparkle_pack [ 'sparkle-pack-aws-my-load-balancers' ]
  ...
end
```

In a SparkleFormation Template/Component/Dynamic:
```ruby
load_balancer_names _array!(registry!(:my_elb, 'public'))
```
The `my_elb` registry will return an ELB name, where the ELB's 'Purpose'
tag matches 'public'.  You can also override `ENV['environment']` by
supplying the `environment parameter`:
```ruby
load_balancer_names _array!(registry!(:my_elb, 'public', 'prod'))
```

Or get an array of all ELBs in a particular VPC, by `ENV['environment']`:
```ruby
parameters(:elbs) do
  type 'String'
  allowed_values registry!(:all_elbs)
end
```

