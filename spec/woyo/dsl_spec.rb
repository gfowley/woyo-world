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
            title 'Home'
            description 'Sweet'
          end
        end
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 1
        home = world.locations[:home]
        home.id.should eq :home
        home.title.should eq 'Home'
        home.description.should eq 'Sweet'
      end

      it 'existing with attributes' do
        world = Woyo::World.new do
          location :home do
            title 'Home'
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
        home.title.should eq 'Home'
        home.description.should eq 'Sweet'
      end

      it 'multiple with attributes' do
        world = Woyo::World.new do
          location :home do
            title 'Home'
            description 'Sweet'
          end
          location :away do
            title 'Away'
            description 'Okay'
          end
        end
        world.should be_instance_of Woyo::World
        world.locations.count.should eq 2
        home = world.locations[:home]
        home.id.should eq :home
        home.title.should eq 'Home'
        home.description.should eq 'Sweet'
        away = world.locations[:away]
        away.id.should eq :away
        away.title.should eq 'Away'
        away.description.should eq 'Okay'
      end
    end


  end

end

