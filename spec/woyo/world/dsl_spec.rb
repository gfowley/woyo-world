require 'spec_helper'
require 'woyo/world/world'

describe 'DSL', stuff: true  do

  title   "Woyo World"
  tagline "World of Your Own"
  url     "https://github.com/iqeo/woyo-world"

  heading      "WOYO : World of Your Own"
  introduction "This gem woyo-world is a Ruby-based DSL (Domain Specific Language) for creating and interacting with a virtual world. A world is comprised of locations to visit, and ways to go between locations."

  context 'world' do

    introduction "A world is comprised of attributes and objects, including locations, items, characters, etc.."
  
    example 'has attributes' do
      heading      "Attributes"
      introduction "A world has attributes that describe and define it's operation."
      codes [
        { code: "world = Woyo::World.new" },
        { code: "world.evaluate do
                   name 'Small'
                   description 'A small world.'
                   start :home
                 end" }
      ]
      before_result "Attributes may be accessed from the world."
      results [
        { code: "world.name",        value: "'Small'",          before: "The 'name' attribute is to be presented to the user" }, 
        { code: "world.description", value: "'A small world.'", before: "The 'description' attrbute is to be presented to the user" }, 
        { code: "world.start",       value: ":home",            before: "The 'start' attribute refers to the location the user will start at in the world...", after: "...in this case 'home'." }, 
      ]
    end

    conclusion "The most interesting worlds contain locations to visit."
    
  end

  context 'locations' do 

    introduction "A location is a place to visit in a world."

    it 'single' do
      heading      "From humble beginnings..."
      introduction "A single location"
      code "world = Woyo::World.new"
      code "world.evaluate do
              location :home do
                name 'My Home'
                description 'Sweet home.'
              end
            end"
      before_result "Locations have an identifier (in this case :home) that is unique within the world." 
      results [
        {
          before: "A location may be referenced like this...",
          code:   "location = world.locations[:home]",
        },
        {
          before: "...or this...",
          code:   "location = world.location :home",
        },
        {
          before: "To get information about the location...",
          code:   "location.id",
          value:  ":home",
        }
      ]
      result "location.name" => "'My Home'"
      result "location.description" => "'Sweet home.'"
      results [
        {
          before: "No matter how sweet, this little world is kind of boring...",
          code:   "world.locations.count",
          value:  "1",
        }
      ]
      conclusion "Let's expand our horizons..."
    end

    it 'redefined' do
      world = Woyo::World.new
      world.evaluate do
        location :house do
          name 'Home'
        end
      end
      world.evaluate do
        location :house do
          description 'Old'
        end
      end
      world.evaluate do
        location :house do
          description 'Sweet'
        end
      end
      expect(world.locations.count).to eq 1
      location = world.locations[:house]
      expect(location.id).to eq :house
      expect(location.name).to eq 'Home'
      expect(location.description).to eq 'Sweet'
    end

    it 'multiple with attributes' do
      world = Woyo::World.new do
        location :home do
          name 'Home'
          description 'Sweet'
        end
        location :away do
          name 'Away'
          description 'Okay'
        end
      end
      expect(world).to be_instance_of Woyo::World
      expect(world.locations.count).to eq 2
      home = world.locations[:home]
      expect(home.id).to eq :home
      expect(home.name).to eq 'Home'
      expect(home.description).to eq 'Sweet'
      away = world.locations[:away]
      expect(away.id).to eq :away
      expect(away.name).to eq 'Away'
      expect(away.description).to eq 'Okay'
    end

  end

  context 'ways' do

    context 'new way' do

      it 'to new location' do
        world = Woyo::World.new do
          location :home do
            way :door do
              name 'Large Wooden Door'
              to :away
            end
          end
        end
        home = world.locations[:home]
        expect(home.ways.count).to eq 1
        door = home.ways[:door]
        expect(door).to be_instance_of Woyo::Way
        expect(door.name).to eq 'Large Wooden Door'
        expect(door.to).to be_instance_of Woyo::Location
        expect(door.to.id).to eq :away
        away = world.locations[:away]
        expect(away.ways.count).to eq 0
        expect(door.to).to eq away
      end

      it 'to existing location' do
        world = Woyo::World.new do
          location :away do
          end
          location :home do
            way :door do
              name 'Large Wooden Door'
              to :away
            end
          end
        end
        home = world.locations[:home]
        expect(home.ways.count).to eq 1
        door = home.ways[:door]
        expect(door).to be_instance_of Woyo::Way
        expect(door.name).to eq 'Large Wooden Door'
        expect(door.to).to be_instance_of Woyo::Location
        expect(door.to.id).to eq :away
        away = world.locations[:away]
        expect(away.ways.count).to eq 0
        expect(door.to).to eq away
      end

      it 'to same location' do
        world = Woyo::World.new do
          location :home do
            way :door do
              name 'Large Wooden Door'
              to :home
            end
          end
        end
        home = world.locations[:home]
        expect(home.ways.count).to eq 1
        door = home.ways[:door]
        expect(door).to be_instance_of Woyo::Way
        expect(door.name).to eq 'Large Wooden Door'
        expect(door.to).to be_instance_of Woyo::Location
        expect(door.to.id).to eq :home
        expect(door.to).to eq home
      end

    end

    context 'existing way' do

      it 'to new location' do
        world = Woyo::World.new do
          location :home do
            way :door do
              name 'Large Wooden Door'
              description "Big, real big!"
            end
            way :door do
              description 'Nicer'
              to :away
            end
          end
        end
        home = world.locations[:home]
        expect(home.ways.count).to eq 1
        door = home.ways[:door]
        expect(door.name).to eq 'Large Wooden Door'
        expect(door.description).to eq "Nicer"
        expect(door.to).to be_instance_of Woyo::Location
        expect(door.to.id).to eq :away
        away = world.locations[:away]
        expect(away.ways.count).to eq 0
        expect(door.to).to eq away
      end

      it 'to existing location' do
        world = Woyo::World.new do
          location :away do
          end
          location :home do
            way :door do
              name 'Large Wooden Door'
              description "Big, real big!"
            end
            way :door do
              description 'Nicer'
              to :away
            end
          end
        end
        home = world.locations[:home]
        expect(home.ways.count).to eq 1
        door = home.ways[:door]
        expect(door.name).to eq 'Large Wooden Door'
        expect(door.description).to eq "Nicer"
        expect(door.to).to be_instance_of Woyo::Location
        expect(door.to.id).to eq :away
        away = world.locations[:away]
        expect(away.ways.count).to eq 0
        expect(door.to).to eq away
      end

      it 'to same location' do
        world = Woyo::World.new do
          location :home do
            way :door do
              name 'Large Wooden Door'
              description "Big, real big!"
            end
            way :door do
              description 'Nicer'
              to :home
            end
          end
        end
        home = world.locations[:home]
        expect(home.ways.count).to eq 1
        door = home.ways[:door]
        expect(door.name).to eq 'Large Wooden Door'
        expect(door.description).to eq "Nicer"
        expect(door.to).to be_instance_of Woyo::Location
        expect(door.to.id).to eq :home
        expect(door.to).to eq home
      end

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

    # it 'new character' do
    #   world = Woyo::World.new do
    #     location :home do
    #       character :jim do
    #       end
    #     end
    #   end
    #   home = world.locations[:home]
    #   home.characters.count.should eq 1
    #   jim = home.characters[:jim]
    #   jim.location.should be home
    # end

    # it 'existing character' do
    #   world = Woyo::World.new do
    #     location :home do
    #       character :jim do
    #         name 'James'
    #         description 'Jolly'
    #       end
    #       character :jim do
    #         description 'Jovial'
    #       end
    #     end
    #   end
    #   home = world.locations[:home]
    #   home.characters.count.should eq 1
    #   jim = home.characters[:jim]
    #   jim.location.should be home
    #   jim.name.should eq 'James'
    #   jim.description.should eq 'Jovial'
    # end

    context 'character' do

      it 'new' do
        world = Woyo::World.new do
          character :jim do
            name 'James'
            description 'Jolly'
          end
        end
        expect(world.characters.count).to eq 1
        expect(world.characters[:jim]).to be_instance_of Woyo::Character
        jim = world.characters[:jim]
        expect(jim.location).to be_nil
        expect(jim.name).to eq 'James'
        expect(jim.description).to eq 'Jolly'
      end

      it 'existing' do
        world = Woyo::World.new do
          character :jim do
            name 'James'
            description 'Jolly'
          end
          character :jim do
            description 'Jovial'
          end
        end
        expect(world.characters.count).to eq 1
        expect(world.characters[:jim]).to be_instance_of Woyo::Character
        jim = world.characters[:jim]
        expect(jim.location).to be_nil
        expect(jim.name).to eq 'James'
        expect(jim.description).to eq 'Jovial'
      end

    end

  end

end

