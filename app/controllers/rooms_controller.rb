class RoomsController < ApplicationController
    before_action :load_entities

    def index
        @rooms = Room.all
    end

    def new
        @room = Room.new
    end

    def create
        @room = Room.new permitted_parameters

        if @room.save
            flash[:success] = "Room #{@room.name} was created successfully"
            redirect_to rooms_path
        else
            render :new
        end
    end

    def edit
    end
    
    def update
        if @room.update_attributes(permitted_parameters)
            flash[:success] = "Room #{@room.name} was updated successfully"
            redirect_to rooms_path
        else
            render :new
        end
    end

    def show
        if @room
            @room_message = RoomMessage.new room: @room
            @room_messages = @room.room_messages
        else
            flash[:success] = "Sorry, Room didn't exist anymore"
            redirect_to rooms_path
        end
    end

    def destroy
        @room = Room.find(params[:id])
        @room_message = RoomMessage.find_by(room_id: params[:id])

        if @room_message
            @room_message.destroy
        end
        @room.destroy
    
        redirect_to rooms_path
    end

    protected
    
    def load_entities
        @rooms = Room.all
        begin
        @room = Room.find(params[:id]) 
        rescue ActiveRecord::RecordNotFound => e
            @room = nil
        end

    end

    def permitted_parameters
        params.require(:room).permit(:name)
    end
end
