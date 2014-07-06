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

    doc 'home' do
      head "From humble beginnings"
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

    doc 'making changes' do
      head "Change begins at home"
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

    doc 'second' do
      head "Expandng horizons" 
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
    text "A Woyo::Way is a directional path between locations."

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

    doc "hit the road" do
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
      text "And a description of the attempt (none in this case)..."
      code "attempt[:going]" => "'Creaky steps lead uncertainly downwards...'"
    end

    doc "going a way" do
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

  context "actions" do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head "Actions"
    text "World objects may have actions that can be invoked, usually via user interaction."
    text "Actions change the state of the world, usually by changing the value of attributes on world objects"

    it "change attributes"
    # doc "change attributes" do
    #   text "Actions may be defined for a world object, in this case, an item."
    #   code pre:  "world.evaluate do",
    #        code:   "item :thing do
    #                   name 'Thing?'
    #                   action two: proc { name = 'Thing Two' }
    #                   action one: proc { name = 'Thing One' }
    #                 end",
    #        post: "end"
    #   text "Initially the name is as defined"
    #   code "thing = world.item :thing" => "world.items[:thing]"
    #   code "thing.name" => "'Thing?'"
    #   text "Invoking action 'one', changes the name."
    #   code "thing.one!"
    #   code "thing.name" => "'Thing One'"
    #   text "Invoking action 'two', changes the name again."
    #   code "thing.two!"
    #   code "thing.name" => "'Thing Two'"
    # end

    it "may be defined as a block"

    it "may be invoked via #do :action"

    it "are listed"
  
  end

  context 'context' do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head 'Context'
    text "Other objects may be referred to in different ways."

    doc 'world' do

    end

    doc 'location' do

    end

    doc 'context' do

    end

  end

  context 'attributes' do

    before :all do
      @world = Woyo::World.new
    end
    def world ; @world ; end

    head "Attributes"

    doc "may be dynamic" do
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

    doc "may access attributes of this object" do
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

    doc "may access attributes of other objects" do
      text "This provides a mechanism for one object to affect another. The Ruby code block may simply refer to an attribute of another object."
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

  end

end

