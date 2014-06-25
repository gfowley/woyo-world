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
  
    example 'also has attributes' do
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

    example 'home' do
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

    example 'making changes' do
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

    example 'second' do
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

    # example "from here to there" do
    #   introduction "A way is defined within a location."
    #   codes [ { pre:  "world.evaluate do",
    #             code:   "location :here do
    #                        way :road do
    #                          to :there
    #                          description 'A short road'
    #                          going       'Takes a long time'
    #                        end
    #                      end",
    #             post: "end" } ]
    #   after_codes "Ways have an identifier (in this case :road) that is unique within that location."
    #   before_results "A way may be referenced like this..."
    #   result "here = world.locations[:here]" => nil
    #   result "way = here.ways[:road]" => nil
    #   results [ { before: "...or this...",
    #               code:   "here = world.location :here" },
    #             { code:   "way = here.way :road" } ]
    #   results [ { before: "The way's attributes include a description that may be included in location representation to the user.",
    #               code:   "way.description", value: "'A short road'" } ]
    #   results [ { before: "The location the way is defined within is the location the way is 'from'.",
    #               code:   "way.from" },
    #             { code:   "way.from.id", value: ":here" } ]
    #   results [ { before: "Ways connect 'to' a location (in this case :there). This location is created if it does not already exist.",
    #               code:   "way.to" },
    #             { code:   "way.to.id", value: ":there" } ]
    # end

    # example "hit the road" do
    #   introduction "Ways connect locations so that a user can move about in your world. Usually upon user input, the user goes a way from location to location. An optional description of the 'going' may be presented."
    #   codes [ { pre:  "world.evaluate do",
    #             code:   "location :room do
    #                        way :stairs do
    #                          to :cellar
    #                          description 'Rickety stairs lead down into darkness.'
    #                          going       'Creaky steps lead uncertainly downwards...'
    #                        end
    #                      end
    #                      location :cellar do
    #                        description 'Dark and damp, as expected.'
    #                      end",
    #             post: "end" } ]
    #   before_results "Accessing the location and way..."
    #   result "room = world.location :room" => nil
    #   result "stairs = room.way :stairs" => nil
    #   results [ { before: "When we try to 'go' a way, the result describes the attempt.",
    #               code:   "attempt = stairs.go", value: "{ go: true, going: 'Creaky steps lead uncertainly downwards...' }" },
    #             { before: "Whether successful or not (true in this case)...",
    #               code:   "attempt[:go]", value: "true" },
    #             { before: "And a description of the attempt (none in this case)...",
    #               code:   "attempt[:going]", value: "'Creaky steps lead uncertainly downwards...'" } ]
    # end

    # example "going a way" do
    #   introduction "Ways may be open or closed, optionally with descriptions for each state. A user cannot go a closed way, and an alternative 'going' description may be presented if attempted."
    #   codes [ { pre:  "world.evaluate do",
    #             code:   "location :room do
    #                        way :stairs do
    #                          to :cellar
    #                          description   open:   'Rickety stairs lead down into darkness.',
    #                                        closed: 'Broken stairs end in darkness.'
    #                          going         open:   'Creaky steps lead uncertainly downwards...',
    #                                        closed: 'The dangerous stairs are impassable.'
    #                        end
    #                      end
    #                      location :cellar do
    #                        description 'Dark and damp, as expected.'
    #                      end",
    #             post: "end" } ]
    #   before_results "Accessing the location and way..."
    #   result "room = world.location :room" => nil
    #   result "stairs = room.way :stairs" => nil
    #   results [ { before: "Ways that go 'to' somewhere are open by default.",
    #               code:   "stairs.open?", value: "true" },
    #             { before: "With an appropriate description.",
    #               code:   "stairs.description", value: "'Rickety stairs lead down into darkness.'" },
    #             { before: "Going an open way succeeds.",
    #               code:   "attempt = stairs.go", value: "{ go: true, going: 'Creaky steps lead uncertainly downwards...' }" },
    #             { code:   "attempt[:go]", value: "true" },
    #             { code:   "attempt[:going]", value: "'Creaky steps lead uncertainly downwards...'" } ]
    #   # results... for closed
    #   #
    # end

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

