require_relative 'modules/company_name'
require_relative 'modules/instance_counter'
require_relative 'modules/validation'
require_relative 'modules/accessors'

class Train
  include CompanyName
  include InstanceCounter
  include Validation
  extend Accessors

  attr_accessor :speed
  attr_reader :name, :type, :carriages, :number

  @@trains = {}

  NUMBER_FORMAT = /^(\w{3})(-\w{2})?$/
  TYPE = { passenger: 'Пассажирский', cargo: 'Грузовой' }.freeze


  validate :number, :format, NUMBER_FORMAT

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @type = type
    @name = name
    validate!
    @speed = 0
    @carriages = []
    @@trains[number] = self
    register_instance
  end

  def type_text
    TYPE[@type]
  end

  def stop
    @speed = 0
  end

  def carriage_naw
    @carriages
  end

  def show_carriage
    unless @carriages.empty?
      puts 'Вагоны поезда:'
      @carriages.each { |carriage| yield(carriage) }
    end
  end

  def add_carriage(carriage)
    if @speed.zero?
      @carriages << carriage
    else
      'Нужно остановиться чтобы прицепить вагон'
    end
    carriage_count
  end

  def del_carriage
    if @speed.zero?
      !@carriages.empty? ? @carriages.pop : 'Вагонов больне нет'
    else
      'Нужно остановиться чтобы отцепить вагон'
    end
    carriage_count
  end

  def route=(route)
    @route = route
    @current_station = @route.all_way[0]
    puts "Поезд принял маршрут, текущая станция #{@current_station}"
  end

  def current_station
    if @route
      puts "Текущая станция: #{@current_station}"
    else
      puts 'маршрут не задан'
    end
  end

  def next_station
    index_station = @route.all_way.index(@current_station)
    @current_station.train_go(self)
    index_station += 1
    @current_station = @route.all_way[index_station]
    @current_station.train_in(self)
  end

  def to_station(station)
    if @route.all_way.include?(station)
      @current_station = next_station
      puts "Поезд переместился на станцию #{@current_station}"
    else
      puts 'Такой станции нет!'
    end
  end

  def show_next_station
    index_station = @route.all_way.index(@current_station)
    next_station = @route.all_way[index_station + 1]
    puts "Следущая станция: #{next_station}"
  end

  def show_prev_station
    index_station = @route.all_way.index(@current_station)
    previous_station = @route.all_way[index_station - 1]
    puts "Предыдущая станция: #{previous_station}" if index_station > 0
  end

  def show_train_info
    puts "номер - #{@number}; тип - #{@type}; вагонов: #{@carriages.size}"
  end

  protected

  attr_writer :carriages

  def carriage_count
    puts "carriages: #{@carriages.size}"
  end
end
