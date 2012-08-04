require 'imperator'
describe Imperator::Command do

  describe "#perform" do
    class CommandTestException < Exception; end
    context "using DSL " do
      class DSLTestCommand < Imperator::Command
        action do
          raise CommandTestException.new 
        end
      end

      let(:command){DSLTestCommand.new}
      it "runs the action block when #perform is called" do
        lambda{command.perform}.should raise_exception(CommandTestException)
      end
    end

    context "using method definition" do
      class MethodTestCommand < Imperator::Command
        def action 
          raise CommandTestException.new
        end
      end
      let(:command){MethodTestCommand.new}
      it "runs the action method when #perform is called" do
        lambda{command.perform}.should raise_exception(CommandTestException)
      end
    end
  end

  describe "actions" do
    context "using DSL" do
      class ActionDSLExampleCommand < Imperator::Command
        action do

        end
      end
    end
  end

  describe "attributes" do
    class AttributeCommand < Imperator::Command
      attribute :gets_default, String, :default => "foo"
      attribute :declared_attr, String
    end

    it "throws away undeclared attributes in mass assignment" do
      command = AttributeCommand.new(:undeclared_attr => "foo")
      lambda{command.undeclared_attr}.should raise_exception(NoMethodError)
    end

    it "accepts declared attributes in mass assignment" do
      command = AttributeCommand.new(:declared_attr => "bar")
      command.declared_attr.should == "bar"
    end

    it "allows default values to be used on commands" do
      command = AttributeCommand.new
      command.gets_default.should == "foo"
    end
    it "overrides default when supplied in constructor args" do
      command = AttributeCommand.new :gets_default => "bar"
      command.gets_default.should == "bar"
    end

    it "will create attributes as json" do
      command = AttributeCommand.new
      command.as_json.should == { "gets_default" => "foo",
                                 "declared_attr" => nil}
    end
  end

end

