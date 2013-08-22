RSpec::Matchers.define :have_passed do
  match do |actual|
    actual.state == "passed"
  end

  failure_message_for_should do
    "have passed, but was #{actual.state}"
  end

  failure_message_for_should_not do
    "not have passed, but did"
  end

  description do
    "should have passed"
  end
end

RSpec::Matchers.define :have_aborted do
  match do |actual|
    actual.state == "failed"
  end

  failure_message_for_should do
    "have failed, but was #{actual.state}"
  end

  failure_message_for_should_not do
    "not have failed, but did"
  end

  description do
    "should have failed"
  end
end
