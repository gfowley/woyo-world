require 'spec_helper'
require 'woyo/world/world'

describe 'DSL', stuff: true  do

  title   "Woyo World"
  tagline "World of Your Own"
  url     "https://github.com/iqeo/woyo-world"

  heading "This is the beginning of the DSL"
  introduction "And a great DSL it is too"
  conclusion "Hope you enjoyed this little DSL"

  let(:world) { Woyo::World.new }

  context 'world' do

    heading "The World"
    introduction "In the beginning..."
    
    example 'has attributes' do
      heading        "Would default to example description"
      introduction   "This is how to do this..."
      before_code    "Here is some code..."
      code "world.evaluate do
              name 'Small'
              description 'A small world'
              start :home
            end"
      eval code
      # code_proc = eval "proc { #{code} }"
      # world.evaluate &code_proc
      after_code     "That was some nice code!"
      before_results "Here come the results..."
      results [
        { code: "world.name",        value: "'Small'",         before: "Where are we ?", after: "Right here." }, 
        { code: "world.description", value: "'A small world'", before: "What's it all about ?", after: "It is what it is." }, 
        { code: "world.start",       value: ":home",           before: "Where to begin ?", after: "At the beginning." }, 
      ]
      after_results  "Those were great results!"
      conclusion     "All's well that ends well."
    end

    it 'contains locations' do
      world.evaluate do
        location :one
        location :two do ; end
        location :three do
          name '3'
        end
      end
      expect(world.locations.count).to eq 3
      expect(world.locations[:one]).to be_instance_of Woyo::Location
      expect(world.locations[:two]).to be_instance_of Woyo::Location
      expect(world.locations[:three]).to be_instance_of Woyo::Location
      expect(world.locations[:three].name).to eq '3'
    end

    conclusion  "And so, in conclusion!"
    
  end

  context 'location' do 

    it 'defined with attributes' do
      world.evaluate do
        location :house do
          name 'Home'
          description 'Sweet'
        end
      end
      location = world.locations[:house]
      expect(location.id).to eq :house
      expect(location.name).to eq 'Home'
      expect(location.description).to eq 'Sweet'
    end

    it 'redefined' do
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

