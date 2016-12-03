require 'aws-sdk-core'

client = ::Aws::ElasticLoadBalancing::Client.new()
policy_descriptions = ::Array.new(
policy_descriptions = client.describe_load_balancer_policies.policy_descriptions
policy_descriptions.collect do |d|
  d['policy_name'] if d['policy_type_name'] == 'SSLNegotiationPolicyType'
end.compact!.sort!

SparkleFormation.component(:elb_security_policies) do
  parameters(:elb_security_policy) do
    type 'String'
    allowed_values policy_descriptions
    default policy_descriptions.last
  end
end