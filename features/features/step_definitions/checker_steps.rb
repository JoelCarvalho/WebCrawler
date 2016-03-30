Before do
  @validator = Validator.new
end


# GIVEN ######################################
Given /^I am on "([^"]*)"$/ do |url|
  @validator.setURL url
end

Given /^My Context is "([^"]*)"(?: With "([^"]*)" Config)?$/ do |context, config|
  @validator.setContext context
  @validator.setConfig config
end

Given /^My Screen Resolution is "([^"]*)"$/ do |resolution|
  @validator.setResolution resolution
end

Given /^I Want Check Guideline(?:s)? "([^"]*)"$/ do |guides|
  @validator.setGuidelines guides
end

Given /^I Want Check Checkpoint(?:s)? "([^"]*)"$/ do |checks|
  @validator.setCheckpoints checks
end


# WHEN ######################################
When /^I Evaluate U&A$/ do
  @validator.evaluate
end


# THEN ######################################
Then /^I Should Not Get (Known|Likely|Potential) Problems$/ do |type|
  @validator.checkNot type
end

Then /^I Should Get Less Than (\d+) (Known|Likely|Potential) Problems$/ do |errors, type|
  @validator.checkLess errors, type
end
