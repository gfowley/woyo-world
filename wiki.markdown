
Ways

Need WorldObject instance to be able to evaluate a block in context !!!

A Woyo::Way is a directional path between locations. They are the edges of the world's location graph.

### First, a road to nowhere
```ruby
location :here do
  way :road do
    to :there
  end
end
```
Ways have an identifier ```way :road``` that is unique within that location.
```ruby
here = world.locations[:here]        => location ... :here
way = here.ways[:road]               => way ... :road
```
Ways are defined in the context of a location. This is the location the way is 'from'.
```ruby
way.from                             => location ... :here 
```
Ways connect to a location ```to :where```. This location is created within the world if it does not already exist...
```ruby
way.to                               => location ... :there
```
...making what could have been a road to nowhere lead somewhere.
### Hit the road
Ways connect locations so that a visitor can move about in your world. Usually upon user input, the user's avatar moves from location to location. The program code to achieve this looks something like...
```ruby
user = world.characters[:user]
user.location                        => location ... :here
user.go :road
user.location                        => location ... :there
```
### Let me count the ways  
Locations can be connected via Ways in many um.. ways, presenting different appearances to the world user.
### Single appearance, bi-directional, visible in both locations
```ruby
location :livingroom do
  way :door do
    to :kitchen
  end
end
```
```ruby
location :kitchen do
  way :door do
    to :livingroom
  end
end
```
### Single appearance, uni-directional, visible in both locations
```ruby
location :treehouse do
  way :slide do
    to: garden
  end
end
```
```ruby
location :garden do
  way :slide do
    # no to...
  end
end
```
### Single appearance, uni-directional, visible in one location
```ruby
location :cloud do
  way :hole do
    to :ground
  end
end
```
```ruby
location :ground do
  # no way...
end
```
### Multiple appearance, each bi-directional, each visible in both locations
```ruby
location :livingroom do
  way :door do
    to :kitchen
  end
  way :arch do
    to :kitchen
  end
end
```
```ruby
location :kitchen do
  way :door do
    to :livingroom
  end
  way :arch do
    to :kitchen
  end
end
```
### Multiple appearance, each uni-directional, each visible in both locations
```ruby
location :treehouse do
  way :slide do
    to: garden
  end
  way :ladder do
    # no to ... who'd climb down a ladder when there's a slide ?
  end
end
```
```ruby
location :garden do
  way :slide do
    # no to ... can't climb a slide
  end
  way :ladder do
    to :treehouse
  end
end
```
### Multiple appearance, each uni-directional, each visible in one location  
```ruby
location :cloud do
  way :hole do
    to :ground
  end
end
```
```ruby
location :ground do
  way :balloon do
    to :cloud
  end
end
```
### Any combination you can dream up
Combine ways to create the this fun playground...
```ruby
location :ground do
  way :balloon do
    to :cloud
  end
  way :ladder do
    to :treehouse
  end
  way :slide
  way :hole do
    to :pit
  end
end
location :treehouse do
  way :slide do
    to :ground
  end
  way :ladder do
    to :ground
  end
  way :branch do
    to :cloud
  end
end
location :cloud do
  way :parachute do
    to :ground
  end
  way :branch do
    to :treehouse
  end
end
```
All roads lead to Rome...
```ruby
location :rome do
  way :north do
    to :rome
  end
  way :south do
    to :rome
  end
  way :east do
    to :rome
  end
  way :west do
    to :rome
  end
end
```




