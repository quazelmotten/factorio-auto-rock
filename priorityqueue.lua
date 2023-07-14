-- PriorityQueue implementation
local PriorityQueue = {}

function PriorityQueue:new()
  local object = {heap = {}, map = {}}
  setmetatable(object, {__index = PriorityQueue})
  return object
end

function PriorityQueue:put(item, priority)
  table.insert(self.heap, {item = item, priority = priority})
  self.map[item] = #self.heap
  self:up_heapify(#self.heap)
end

function PriorityQueue:get()
  local top = self.heap[1]
  self.map[top.item] = nil
  local last = table.remove(self.heap)
  if #self.heap > 0 then
    self.heap[1] = last
    self.map[last.item] = 1
    self:down_heapify(1)
  end
  return top.item
end

function PriorityQueue:empty()
  return #self.heap == 0
end

function PriorityQueue:up_heapify(index)
  local parent = math.floor(index / 2)
  if parent > 0 and self.heap[index].priority < self.heap[parent].priority then
    self:swap(index, parent)
    self:up_heapify(parent)
  end
end

function PriorityQueue:down_heapify(index)
  local child1 = index * 2
  local child2 = index * 2 + 1
  local min = index
  if child1 <= #self.heap and self.heap[child1].priority < self.heap[min].priority then
    min = child1
  end
  if child2 <= #self.heap and self.heap[child2].priority < self.heap[min].priority then
    min = child2
  end
  if min ~= index then
    self:swap(index, min)
    self:down_heapify(min)
  end
end

function PriorityQueue:swap(index1, index2)
  local temp = self.heap[index1]
  self.heap[index1] = self.heap[index2]
  self.heap[index2] = temp
  self.map[self.heap[index1].item] = index1
  self.map[self.heap[index2].item] = index2
end

return PriorityQueue