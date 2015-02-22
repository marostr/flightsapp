class BaseDecorator

  attr_accessor :object

  delegate :id, to: :object

  def initialize(object)
    @object = object
    if @object.is_a?(ActiveRecord::Relation)
      @object = @object.map { |obj| decorator_class.new(obj) }
    end
  end

  def method_missing(method, *args, &block)
    object.public_send(method, *args, &block)
  end

  def decorator_class
    (@object.first.class.to_s + 'Decorator').constantize
  end
end
