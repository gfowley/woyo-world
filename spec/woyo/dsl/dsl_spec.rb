require 'spec_helper'
require 'woyo/world/world'

describe 'DSL' do

  title   "Woyo World"
  tagline "World of Your Own"
  url     "https://github.com/iqeo/woyo-world"

  head "WOYO : World of Your Own"
  text "This gem woyo-world is a Ruby-based DSL (Domain Specific Language) for creating and interacting with a virtual world. A world is comprised of locations to visit, and ways to go between locations."

  context 'world' do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head "World"
    text "A world is comprised of attributes and objects, including locations, items, characters, etc.."
  
    doc 'has attributes' do
      head "Attributes"
      text "A world has attributes that describe and define it's operation."
      code pre:  "world.evaluate do",
           code:   "name 'Small'
                    description 'A small world.'
                    start :home",
           post: "end"
      text "Attributes may be accessed from the world."
      text "The 'name' attribute is to be presented to the user" 
      code "world.name" => "'Small'"
      text "The 'description' attrbute is to be presented to the user"
      code "world.description" => "'A small world.'"
      text "The 'start' attribute refers to the location the user will start at in the world..."
      code "world.start" => ":home"
      text "...in this case 'home'."
    end
    
    text "The most interesting worlds contain locations to visit."

  end

  context 'locations' do 

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head "Locations"
    text "A location is a place to visit in a world."

    doc  "from humble beginnings" do
      text "A single location"
      code pre:  "world.evaluate do",
           code:   "location :home do
                      name 'My Home'
                      description 'This old house.'
                    end",
           post: "end"
      text "Locations have an identifier (in this case :home) that is unique within the world." 
      text "A location may be referenced like this..."
      code "home = world.locations[:home]"
      text "...or this..."
      code "home = world.location :home"
      text "To get information about the location..."
      code "home.id" => ":home"
      code "home.name" => "'My Home'"
      code "home.description" => "'This old house.'"
      text "This is a nice old house, but let's make some changes to it..."
    end

    doc "change begins at home" do
      text "Let's make some changes to this location."
      code pre:  "home = world.location :home
                  world.evaluate do",
           code:   "location :home do
                      description 'Sweet home.'
                    end",
           post: "end"
      text "The new description replaces the old one."
      text "Now our home looks like this..."
      code "home.name" => "'My Home'"
      code "home.description" => "'Sweet home.'"
      text "No matter how sweet, this little world is not very interesting..."
      code "world.locations.count" => "1"
      text "Let's expand our horizons..."
    end

    doc "expandng horizons" do
      text "Add a location to our world"
      code pre:  "home = world.location :home
                    world.evaluate do",
           code:   "location :garden do
                      name 'Garden'
                      description 'A green leafy place.'
                    end",
           post: "end"
      text "Now our world is a little more interesting..."
      code "world.locations.count" => "2"
      code "garden = world.location :garden"
      text "This seems like a nice garden..."
      code "garden.id" => ":garden"
      code "garden.name" => "'Garden'"
      code "garden.description" => "'A green leafy place.'"
      text "We'd like to visit this garden, but there's no way, really..."
      code "home.ways"   => "{}"
      code "garden.ways" => "{}"
      text "To go from location to location we need Ways"
    end

  end

  context 'ways' do

    before :all do
      @world = Woyo::World.new
    end

    def world ; @world ; end

    head "Ways"
    text "A way is a directional path between locations."

    doc "from here to there" do
      text "A way is defined within a location."
      code pre:  "world.evaluate do",
           code:   "location :here do
                      way :road do
                        to :there
                        description 'A short road'
                        going       'Takes a long time'
                      end
                    end",
           post: "end"
      text "Ways have an identifier (in this case :road) that is unique within that location."
      text "A way may be referenced like this..."
      code "here = world.locations[:here]" => nil
      code "way = here.ways[:road]" => nil
      text "...or this..."
      code "here = world.location :here"
      code "way = here.way :road"
      text "The way's attributes include a description that may be included in location representation to the user."
      code "way.description" => "'A short road'"
      text "The location the way is defined within is the location the way is 'from'."
      code "way.from.id" => ":here"
      text "Ways connect 'to' a location (in this case :there). This location is created if it does not already exist."
      code "way.to.id" => ":there"
    end

    doc "going a way" do
      text "Ways connect locations so that a user can move about in your world. Usually upon user input, the user goes a way from location to location. An optional description of the 'going' may be presented."
      code pre:  "world.evaluate do",
           code:   "location :room do
                      way :stairs do
                        to :cellar
                        description 'Rickety stairs lead down into darkness.'
                        going       'Creaky steps lead uncertainly downwards...'
                      end
                    end
                    location :cellar do
                      description 'Dark and damp, as expected.'
                    end",
           post: "end"
      text "Accessing the location and way..."
      code "room = world.location :room" => nil
      code "stairs = room.way :stairs" => nil
      text "When we try to 'go' a way, the result describes the attempt."
      code "attempt = stairs.go" => "{ go: true, going: 'Creaky steps lead uncertainly downwards...' }"
      text "Whether successful or not (true in this case)..."
      code "attempt[:go]" => "true"
      text "And a description of the attempt..."
      code "attempt[:going]" => "'Creaky steps lead uncertainly downwards...'"
    end

    doc "on the way" do
      text "Ways may be open or closed, optionally with descriptions for each state. A user cannot go a closed way, and an alternative 'going' description may be presented if attempted."
      code pre:  "world.evaluate do",
           code:   "location :room do
                      way :stairs do
                        to :cellar
                        description   open:   'Rickety stairs lead down into darkness.',
                                      closed: 'Broken stairs end in darkness.'
                        going         open:   'Creaky steps lead uncertainly downwards...',
                                      closed: 'The dangerous stairs are impassable.'
                      end
                    end
                    location :cellar do
                      description 'Dark and damp, as expected.'
                    end",
           post: "end"
      text "Accessing the location and way..."
      code "room = world.location :room" => nil
      code "stairs = room.way :stairs" => nil
      text "Ways that go 'to' a location are open by default."
      code "stairs.open?" => "true"
      text "With an appropriate description."
      code "stairs.description" => "'Rickety stairs lead down into darkness.'"
      text "Going an open way succeeds."
      code "attempt = stairs.go" => "{ go: true, going: 'Creaky steps lead uncertainly downwards...' }"
      code "attempt[:go]" => "true"
      code "attempt[:going]" => "'Creaky steps lead uncertainly downwards...'"
      text "A way may be closed."
      code "stairs.close!"
      code "stairs.closed?" => "true"
      text "The way has an appropriate description."
      code "stairs.description" => "'Broken stairs end in darkness.'"
      text "Going a closed way fails."
      code "attempt = stairs.go" => "{ go: false, going: 'The dangerous stairs are impassable.' }"
      code "attempt[:go]" => "false"
      code "attempt[:going]" => "'The dangerous stairs are impassable.'"
    end

  end

  context 'items' do

    head 'Items'

    doc 'stuff here'
    # do
    #   pending
    # end

  end

  context 'attributes' do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head "Attributes"

    doc "things change" do
      text "Attribute values may be dynamic, their value determined by a Ruby code block. The value of the last expression in the block is the value assigned to the attribte."
      code pre:  "world.evaluate do",
           code:   "item :clock do
                      attribute :time do
                        Time.now.to_s
                      end
                    end",
           post: "end"
      text "'Time.now.to_s' is a Ruby expression that returns the current time in human readable string. Since it is the last (only) expression in the code block, it's value will be assigned to the attribute ':time'."
      code "clock = world.item :clock"
      code "clock.time" => "Time.now.to_s"
      text "The code block will be evaluated each time the attribute is accessed, returning the current time. Let's wait a second and check the time again."
      code "sleep 1"
      code "clock.time" => "Time.now.to_s"
    end

    doc "these things" do
      text "A dynamic attribute can access other attributes of the same object."
      text "A simple calculator."
      code pre:  "world.evaluate do",
           code:   "item :calculator do
                      attribute a: 1, b: 2
                      attribute :sum do
                        a + b
                      end
                    end",
           post: "end"
      text "Attribute 'sum' accesses attributes 'a' and 'b' and adds them."
      code "calculator = world.item :calculator"
      code "calculator.sum" => "3"
      text "Being a dynamic attribute, changes to the related attributes affect the result."
      code "calculator.a = 4"
      code "calculator.b = 5"
      code "calculator.sum" => "9"
    end

    doc "those things" do
      text "Dynamic attributes provide a mechanism for one object to affect another. The Ruby code block may simply refer to an attribute of another object."
      code pre:  "world.evaluate do",
           code:   "item :bulb do
                      attribute color: 'red'
                    end
                    item :lamp do    
                      attribute :light do
                        ( world.item :bulb ).color
                      end
                    end",
           post: "end"
      text "The lamp's light depends on the bulb color."
      code "lamp = world.item :lamp"
      code "lamp.light" => "'red'"
      text "Let's change the bulb."
      code "bulb = world.item :bulb"
      code "bulb.color = 'green'"
      text "New we see the lamp in a new light."
      code "lamp.light" => "'green'"
    end

    text "All things... to access attributes of other objects, see 'Context'."
    text "Being Ruby code, dynamic attributes could be used to make changes to other world objects, attributes, etc.., even to execute any arbitrary Ruby code. Don't do it, this way lies madness."
    text "Dynamic attributes are intended only to provide a dynamic value to a attribute, not to change other attributes or world objects. Another mechanism: 'Actions', is intended to modify the world."

  end

  context 'context' do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head 'Context'
    text "Other objects may be referred to in different ways."

    doc 'world'
    # do
    #   pending
    # end             

    doc 'location'
    # do
    #   pending
    # end             

    doc 'context'
    # do
    #   pending
    # end             

  end

  context "actions" do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head "Actions"
    text "World objects may have actions that can be invoked, usually via user interaction."
    text "Actions change the state of the world, usually by changing the value of attributes on world objects"

    doc "making changes" do
      text "Actions may be defined for a world object, in this case, an item. Actions have an id, and optionally a name and description. The steps an action is to perform is contained within an 'execution' block, which executes in the context of the containing world object."
      code pre:  "world.evaluate do",
           code:   "location :here do
                      item :thing do
                        name 'Thing One'
                        description 'Rename thing 1 to thing 2'
                        action :rename do
                          execution do
                            name 'Thing Two'
                          end
                        end
                      end
                    end",
           post: "end"
      text "Initially the name is as defined"
      code "location = world.location :here"
      code "thing = location.item :thing" => "world.locations[:here].items[:thing]"
      code "thing.name" => "'Thing One'"
      text "Executing rename action changes the name."
      code "thing.action(:rename).execute"
      code "thing.name" => "'Thing Two'"
    end

    doc "describing the action " do
      text "When an action is executed it returns information about the action, including a description of the action."
      code pre:  "world.evaluate do",
           code:   "location :here do
                      item :thing do
                        name 'Thing One'
                        action :rename do
                          description 'Rename thing 1 to thing 2'
                          describe 'Thing is renamed'
                          execution do
                            name 'Thing Two'
                          end
                        end
                      end
                    end",
           post: "end"
      text "Initially the name is as defined"
      code "location = world.location :here"
      code "thing = location.item :thing" => "world.locations[:here].items[:thing]"
      code "thing.name" => "'Thing One'"
      text "Executing rename action returns a result."
      code "result = thing.action(:rename).execute" => "'placeholder for results hash'" 
      text "Of course, the name was changed as expected"
      code "thing.name" => "'Thing Two'"
    end

    doc "getting results" do
      pending
    end

  end

=begin

  action :do_something do

    name        "Do something!"
    description "Don't just stand there..."

    result success: "I am doing something.",
           failure: "I can't do anything."
                
    # execution is wrapped by execute method which returns hash:
    # { result: :success,
    #   description: "matching description" } 
    # caller should know how to handle resulti !?
    
    execution do
      # runs in parent object context
      # return result, matching description will be returned to user
      :success 
    end

  end

=end


end

