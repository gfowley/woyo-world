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
  
    doc 'also has attributes' do
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
      text "Ways that go 'to' somewhere are open by default."
      code "stairs.open?" => "true"
      text "With an appropriate description."
      code "stairs.description" => "'Rickety stairs lead down into darkness.'"
      text "Going an open way succeeds."
      code "attempt = stairs.go" => "{ go: true, going: 'Creaky steps lead uncertainly downwards...' }"
      code "attempt[:go]" => "true"
      code "attempt[:going]" => "'Creaky steps lead uncertainly downwards...'"
      # results... for closed
    end

    context 'going' do

      before :all do
        @world = Woyo::World.new do
          location :room do
            way :stairs do
              to :cellar
              description   open: 'Rickety stairs lead down into darkness.',
                closed: 'Broken stairs end in darkness.'
              going         open: 'Creaky steps lead uncertainly downwards...',
                closed: 'The dangerous stairs are impassable.'
            end
          end
          location :cellar do
            description 'Dark and damp, as expected.'
          end
        end
      end

      it 'an open way' do
        room = @world.locations[:room]
        stairs = room.ways[:stairs]
        expect(stairs.to.id).to eq :cellar
        expect(stairs).to be_open
        expect(stairs.description).to eq 'Rickety stairs lead down into darkness.'
        expect(stairs.go).to eq ( { go: true, going: 'Creaky steps lead uncertainly downwards...' } )
      end

      it 'a closed way' do
        room = @world.locations[:room]
        stairs = room.ways[:stairs]
        expect(stairs.to.id).to eq :cellar
        stairs.close!
        expect(stairs).to be_closed
        expect(stairs.description).to eq 'Broken stairs end in darkness.'
        expect(stairs.go).to eq ( { go: false, going: 'The dangerous stairs are impassable.' } )
      end

    end

  end

end

