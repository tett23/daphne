# coding: utf-8

class IssueStat
  include DataMapper::Resource

  property :id, Serial
  property :create_count, Integer
  property :close_count, Integer
  property :aggrigate_on, Date
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :account, :required=>false
  belongs_to :project, :required=>false
end
