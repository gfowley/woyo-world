require 'woyo/world'

describe 'DSL' do

  context 'world' do

    context 'location' do 

      it 'new without block' do
        world = Woyo::World.new do
          location :home
          location :away
          location :lost
        end
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 3
      end

      it 'new with empty block' do
        world = Woyo::World.new do
          location :home do ; end
          location :away do ; end
          location :lost do ; end
        end
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 3
      end

      it 'new with attributes' do
        world = Woyo::World.new do
          location :home do
            name 'Home'
            description 'Sweet'
          end
        end
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 1
        home = world.locations[:home]
        home.id.should eq :home
        home.name.should eq 'Home'
        home.description.should eq 'Sweet'
      end

      it 'existing with attributes' do
        world = Woyo::World.new do
          location :home do
            name 'Home'
            description 'Okay'
          end
          location :home do
            description 'Sweet'
          end
        end
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 1
        home = world.locations[:home]
        home.id.should eq :home
        home.name.should eq 'Home'
        home.description.should eq 'Sweet'
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
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 2
        home = world.locations[:home]
        home.id.should eq :home
        home.name.should eq 'Home'
        home.description.should eq 'Sweet'
        away = world.locations[:away]
        away.id.should eq :away
        away.name.should eq 'Away'
        away.description.should eq 'Okay'
      end

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
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.should be_instance_of Woyo::Way
          door.name.should eq 'Large Wooden Door'
          door.to.should be_instance_of Woyo::Location
          door.to.id.should eq :away
          away = world.locations[:away]
          away.ways.count.should eq 0
          door.to.should eq away
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
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.should be_instance_of Woyo::Way
          door.name.should eq 'Large Wooden Door'
          door.to.should be_instance_of Woyo::Location
          door.to.id.should eq :away
          away = world.locations[:away]
          away.ways.count.should eq 0
          door.to.should eq away
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
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.should be_instance_of Woyo::Way
          door.name.should eq 'Large Wooden Door'
          door.to.should be_instance_of Woyo::Location
          door.to.id.should eq :home
          door.to.should eq home
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
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.name.should eq 'Large Wooden Door'
          door.description.should eq "Nicer"
          door.to.should be_instance_of Woyo::Location
          door.to.id.should eq :away
          away = world.locations[:away]
          away.ways.count.should eq 0
          door.to.should eq away
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
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.name.should eq 'Large Wooden Door'
          door.description.should eq "Nicer"
          door.to.should be_instance_of Woyo::Location
          door.to.id.should eq :away
          away = world.locations[:away]
          away.ways.count.should eq 0
          door.to.should eq away
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
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.name.should eq 'Large Wooden Door'
          door.description.should eq "Nicer"
          door.to.should be_instance_of Woyo::Location
          door.to.id.should eq :home
          door.to.should eq home
        end

      end

    end

  end

end

