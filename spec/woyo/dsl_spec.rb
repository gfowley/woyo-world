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

      context 'way' do

        it 'new' do
          world = Woyo::World.new do
            location :home do
              way :door do
                name 'Large Wooden Door'
                description "Big, real big!"
                to :away
              end
            end
          end
          home = world.locations[:home]
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.should be_instance_of Woyo::Way
          door.name.should eq 'Large Wooden Door'
          door.description.should eq "Big, real big!"
          door.to.should eq :away
        end

        it 'existing' do
          world = Woyo::World.new do
            location :home do
              way :door do
                name 'Large Wooden Door'
                description "Big, real big!"
                to :away
              end
              way :door do
                name 'Same door'
              end
            end
          end
          home = world.locations[:home]
          home.ways.count.should eq 1
          door = home.ways[:door]
          door.name.should eq 'Same door'
          door.description.should eq "Big, real big!"
          door.to.should eq :away
        end
      end

    end

  end

end

