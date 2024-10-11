#!/bin/bash

TODO_DIR="$HOME/.todo"
TODO_FILE="$TODO_DIR/todo.txt"

initialize_todo_file() {
	# Check if the directory exists, if not, create it
	if [[ ! -d "$TODO_DIR" ]]; then
		mkdir -p "$TODO_DIR"
		echo "Created directory $TODO_DIR"
	fi

	# Create the todo file if it doesn't exist
	if [[ ! -f "$TODO_FILE" ]]; then
		touch "$TODO_FILE"
		echo "Created todo file $TODO_FILE"
	fi
}

list_pending_tasks() {
	grep -nE '^[0-9]+,false,' "$TODO_FILE" | cut -d ',' -f 1,2,3
}

list_all_tasks() {
	cat "$TODO_FILE" | cut -d ',' -f 1,2,3
}

list_completed_tasks() {
	grep -nE '^[0-9]+,true,' "$TODO_FILE" | cut -d ',' -f 1,2,3
}

add_task() {
	id=$(($(tail -n 1 "$TODO_FILE" | cut -d ',' -f 1) + 1))
	echo "$id,false,$1,$2" >>"$TODO_FILE"
	echo "Task added with id $id"
}

get_task() {
	task_info=$(grep -nE "^$1," "$TODO_FILE")
	if [[ -n $task_info ]]; then
		id=$(echo "$task_info" | cut -d ',' -f 1)
		status=$(echo "$task_info" | cut -d ',' -f 2)
		title=$(echo "$task_info" | cut -d ',' -f 3)
		description=$(echo "$task_info" | cut -d ',' -f 4)
		echo "ID: $id"
		echo "$title"
		echo "$description"
	else
		echo "Task with id $1 not found"
	fi
}

delete_task() {
	sed -i "${1}d" "$TODO_FILE"
	echo "Task with id $1 deleted"
}

finish_task() {
	sed -i "${1}s/,false/,true/" "$TODO_FILE"
	echo "Task with id $1 marked as done"
}

usage() {
	echo "Usage: $0 [option]"
	echo "Options:"
	echo "  all            List all tasks"
	echo "  pending        List pending tasks"
	echo "  done           List completed tasks"
	echo "  add            Add a new task"
	echo "  delete <id>    Delete task with specified id"
	echo "  finish <id>    Mark task with specified id as done"
	echo "  get <id>       Get details of task with specified id"
}

# Initialize todo file and directory
initialize_todo_file

case "$1" in
all)
	list_all_tasks
	;;
pending)
	list_pending_tasks
	;;
done)
	list_completed_tasks
	;;
add)
	read -p "Enter task title: " title
	read -p "Enter task description: " description
	add_task "$title" "$description"
	;;
delete)
	if [[ -z $2 ]]; then
		echo "Please provide id to delete"
	else
		delete_task "$2"
	fi
	;;
finish)
	if [[ -z $2 ]]; then
		echo "Please provide id to mark as done"
	else
		finish_task "$2"
	fi
	;;
get)
	if [[ -z $2 ]]; then
		echo "Please provide id to get task details"
	else
		get_task "$2"
	fi
	;;
*)
	usage
	;;
esac
