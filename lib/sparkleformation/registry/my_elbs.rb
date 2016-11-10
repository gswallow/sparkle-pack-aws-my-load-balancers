require 'aws-sdk-core'

my_vpc = ::String.new
my_elbs = ::Array.new
ec2 = ::Aws::EC2::Client.new
elb = ::Aws::ElasticLoadBalancing::Client.new

ec2.describe_vpcs.vpcs.each do |vpc|
  if !vpc.tags.keep_if{ |tag| tag.key.capitalize == "Environment" && tag.value == ENV['environment'] }.empty?
    my_vpc = vpc.vpc_id
  end
end

if my_vpc.empty?
  my_vpc = ec2.describe_vpcs.vpcs.collect { |vpc| vpc.vpc_id if vpc.is_default }.compact.first
end

my_elbs = elb.describe_load_balancers.load_balancer_descriptions.map { |lb| lb if lb.vpc_id == my_vpc }.compact

SfnRegistry.register(:all_elbs) do
  my_elbs.map(&:load_balancer_name)
end

SfnRegistry.register(:my_elb) do |purpose, environment = ENV['environment']|
  found_elb = ::String.new
  my_elbs.map(&:load_balancer_name).each do |lb_name|
    tags = elb.describe_tags(load_balancer_names: [ lb_name ]).tag_descriptions.map(&:tags).first rescue []
    if !tags.find_index { |t| t.key == 'Environment' && t.value == environment }.nil?
      if !tags.find_index { |t| t.key == 'Purpose' && t.value == purpose }.nil?
        found_elb << lb_name
        break
      end
    end
  end
  found_elb
end
