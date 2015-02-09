# This migration comes from mokio (originally 20141024131942)
class MigrateExternalCodesToExternalScripts < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :mokio_external_codes
      if ActiveRecord::Base.connection.table_exists? :mokio_external_scripts
        ActiveRecord::Base.transaction do

          begin

          query = "INSERT INTO mokio_external_scripts (name,script) SELECT name,code FROM mokio_external_codes"
          ActiveRecord::Base.connection.execute(query)

          query = "DROP TABLE mokio_external_codes"
          ActiveRecord::Base.connection.execute(query)

          rescue Exception => exc
            @_errors = true
            puts ("Something went wrong (mokio_external_codes to mokio_external_scripts - migration ) :  #{exc.message}")
          end

          raise ActiveRecord::Rollback if @_errors
        end
      end
    end
  end
end
