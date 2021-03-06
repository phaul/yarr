# frozen_string_literal: true

require_relative 'db_helper'

DB.create_table(:origins) do
  primary_key :id
  String :name, size: 50, null: false
end

DB.create_table(:klasses) do
  primary_key :id
  foreign_key :origin_id, :origins, null: false
  index %i[name flavour origin_id], unique: true

  String :name, null: false
  String :flavour, size: 50, null: false # class or module
  String :url, size: 50, null: false
end

DB.create_table(:methods) do
  primary_key :id
  foreign_key :klass_id, :klasses, null: false
  foreign_key :origin_id, :origins, null: false
  index %i[name flavour klass_id], unique: true

  String :name, null: false
  String :flavour, size: 50, null: false # class or instance
  String :url, size: 50, null: false
end

DB.create_table(:facts) do
  primary_key :id
  String :name, type: String, null: false
  Integer :count, null: false, default: 0
  String :content, null: false

  index :name, unique: true
end
