#Imperator
Imperator is a small gem to help with command objects. The [command pattern](http://c2.com/cgi/wiki?CommandPattern) is a design pattern used to encapsulate all of the information needed to execute a method or process at a point in time. In a web application, commands are typically used to delay execution of a method from the request cycle to a background processor.

###Why use commands?
The problem with controllers in Rails is that they're a part of the web domain—their job is to respond to requests, and ONLY to respond to requests. Anything that happens between the receipt of a request and sending a response is Somebody Else's Job™. Commands are that Somebody Else™. Commands are also very commonly utilized to put work into the background. 

Why are commands an appropriate place to handle that logic? Commands give you the opportunity to encapsulate all of the logic required for an interaction in one spot. Sometimes that interaction is as simple as a method call—more often there are several method calls involved, not all of which deal with domain logic (and thus, are inappropriate for inclusion on the models). Commands give you a place to bring all of these together in one spot without increasing coupling in your controllers or models.

Commands can also be regarded as the contexts from DCI.

###Validation 
Commands also give you an appropriate place to handle interaction validation. Validation is most often regarded as a responsibility of the data model. This is a poor fit, because the idea of what's valid for data is very temporally tied to the understanding of the business domain at the time the data was created. Data that's valid today may well be invalid tomorrow, and when that happens you're going to run into a situation where your ActiveRecord models will refuse to work with old data that is no longer valid. Commands don't absolve you of the need to migrate your data when business requirements change, but they do let you move validation to the interaction where it belongs.

Commands can also be used on forms in place of ActiveRecord models, when
the ActiveModel::Naming interface is included in the command class.
Imperator doesn't have a dependency on
ActiveRecord/ActiveModel/ActiveSupport, but readily supports most of the
AM interfaces like validations.  These are trivial to include so support
is not built into Imperator intentionally.

###TODO
* test coverage—Imperator was extracted out of some other work, and coverage was a part of those test suites.
* Ensure compatibility with DJ, Resque and Sidekiq

#Using Imperator

##Requirements:
* Virtus (https://github.com/solnic/virtus)

##Installation
 In your Gemfile:
```ruby
gem 'imperator'
```
##Usage

###Creating the command:
```ruby
    class DoSomethingCommand < Imperator::Command
      attribute :some_object_id
      attribute :some_value

      validates_presence_of :some_object_id

      action do
        obj = SomeObject.find(self.some_object_id)
        obj.do_something(self.some_value)
      end
    end
```
###Using a command on a form builder
First, you'll need to make your commands adhere to ActiveModel's naming
interface:

In your Gemfile:
```ruby
    gem "activemodel"
```

Your Command class:
```ruby
    class DoSomethingCommand < Imperator::Command
      include ActiveModel::Naming
      #...
    end
```

Then you can use them on a form just as you would a model:
```ruby
    <%= form_for(@command, :as => :do_something, :url => some_resource_path(@command.some_object_id), :method => :put) do |f| %>
    ...
    <% end %>
```
###Using a command
```ruby
    class SomeController < ApplicationController
      def update
        command = DoSomethingCommand.new(params[:do_something])
        if command.valid?
          command.perform
          redirect_to root_url
        else
          render edit_some_resource_path(command.some_object_id)
        end
      end
    end
```
###Using a command in the background (Delayed::Job)
```ruby
    Delayed::Job.enqueue command
```
###Using a background processor
You can create a custom background processor very easily. It merely
needs to implement the class method `#commit`
```ruby
    class Imperator::NullBackgroundProcessor
      def self.commit(command, options = nil)
        command.perform
      end
    end
```
You can also pass options to the background processor either by the
command or instance
```ruby
    class CompletePurchase < Imperator::Command
      background :queue => "high"
      
      def action
      end
    end

    command = CompletePurchase.new
    command.commit(:queue => "low")
```

###Contributors
Many thanks to the following contributors for bugfixes, testing, and
additional functionality

* Jason Staten (@statianzo)
* Jay Adkisson (@jayferd)
* Nick Maloney (@nmaloney)
* Grégory Horion (@gregory)

		  
