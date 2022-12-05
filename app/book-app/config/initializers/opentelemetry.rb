require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/instrumentation/all'
require 'opentelemetry/propagator/xray'

if ENV['ENABLE_OTEL'].present?
  OpenTelemetry::SDK.configure do |c|
    c.service_name = 'book-app'
    c.id_generator = OpenTelemetry::Propagator::XRay::IDGenerator
    c.use_all # enables all instrumentation
  end
end