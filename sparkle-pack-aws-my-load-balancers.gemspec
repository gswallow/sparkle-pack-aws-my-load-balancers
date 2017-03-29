Gem::Specification.new do |s|
  s.name = 'sparkle-pack-aws-my-load-balancers'
  s.version = '0.0.2'
  s.licenses = ['MIT']
  s.summary = 'AWS My Load Balancers SparklePack'
  s.description = 'SparklePack to detect load balancers in a VPC whose tags match specified filters.'
  s.authors = ['Greg Swallow']
  s.email = 'gswallow@indigobio.com'
  s.homepage = 'https://github.com/gswallow/sparkle-pack-aws-my-load-balancers'
  s.files = Dir[ 'lib/sparkleformation/registry/*' ] + %w(sparkle-pack-aws-my-load-balancers.gemspec lib/sparkle-pack-aws-my-load-balancers.rb)
  s.add_runtime_dependency 'aws-sdk-core', '~> 2'
end
