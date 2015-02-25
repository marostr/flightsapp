module ActivModel
  module Observing
    extend ActiveSupport::Concern

    module ClassMethods
      def observers=(*values)
        observers.replace(values.flatten)
      end

      def observers
        @observers ||= ObserverArray.new(self)
      end

      def observer_instances
        @observer_instances ||= []
      end

      def instantiate_observers
        observers.each { |o| instantiate_observer(o) }
      end

      def add_observer(observer)
        unless observer.respond_to? :update
          raise ArgumentError, "observer needs to respond to 'update'"
        end
        observer_instances << observer
      end

      def notify_observers(*args)
        observer_instances.each { |observer| observer.update(*args) }
      end

      protected

      def instantiate_observer(observer)
        if observer.respond_to?(:to_sym)
          observer = observer.to_s.camelize.constantize
        end
        if observer.respond_to?(:instance)
          observer.instance
        else
          raise ArgumentError,
            "#{observer} responding to the method :instance. " +
            "Example: Price.observers = :flight # calls " +
            "Flight.instance"
        end
      end

      def inherited(subclass)
        super
        notify_observers :observed_class_inherited, subclass
      end
    end

    def notify_observers(method, *extra_args)
      self.class.notify_observers(method, self, *extra_args)
    end
  end

  class Observer
    include Singleton

    class << self

      def observe(*models)
        models.flatten!
        models.collect! { |model| model.respond_to?(:to_sym) ? model.to_s.camelize.constantize : model }
        singleton_class.redefine_method(:observed_classes) { models }
      end

      def observed_classes
        Array(observed_class)
      end

      def observed_class
        name[/(.*)Observer/, 1].try :constantize
      end
    end

    def initialize
      observed_classes.each { |klass| add_observer!(klass) }
    end

    def observed_classes
      self.class.observed_classes
    end

    def observed_class_inherited(subclass)
      self.class.observe(observed_classes + [subclass])
      add_observer!(subclass)
    end

    protected

    def add_observer!(klass)
      klass.add_observer(self)
    end

  end
end
