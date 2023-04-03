extends Control

# Assigning variables that reference the color nodes
onready var red_forward_label := $Colors/Red/ForwardLabel
onready var red_backward_label := $Colors/Red/BackwardLabel
onready var blue_forward_label := $Colors/Blue/ForwardLabel
onready var blue_backward_label := $Colors/Blue/BackwardLabel
onready var green_forward_label := $Colors/Green/ForwardLabel
onready var green_backward_label := $Colors/Green/BackwardLabel
onready var yellow_forward_label := $Colors/Yellow/ForwardLabel
onready var yellow_backward_label := $Colors/Yellow/BackwardLabel

onready var info_label := $InfoLabel

# Define the states and observations
var states = ["Red", "Blue", "Green", "Yellow"]
var observations = ["Alpha", "Beta", "Charlie", "Delta"]

# Define the initial state probabilities
var initial_prob = {"Red": 0.25, "Blue": 0.25, "Green": 0.25, "Yellow": 0.25}

# Define the state transition probabilities
var transition_prob = {"Red": {"Red": 0.6, "Blue": 0.2, "Green": 0.05, "Yellow": 0.15}, "Blue": {"Red": 0.1, "Blue": 0.4, "Green": 0.2, "Yellow": 0.3}, "Green": {"Red": 0.8, "Blue": 0.05, "Green": 0.1, "Yellow": 0.05}, "Yellow": {"Red": 0.2, "Blue": 0.2, "Green": 0.3, "Yellow": 0.3}}

# Define the observation emission probabilities
var emission_prob = {"Red": {"Alpha": 0.1, "Beta": 0.6, "Charlie": 0.2, "Delta": 0.1}, "Blue": {"Alpha": 0.2, "Beta": 0.3, "Charlie": 0.3, "Delta": 0.2}, "Green": {"Alpha": 0.7, "Beta": 0.01, "Charlie": 0.2, "Delta": 0.09}, "Yellow": {"Alpha": 0.25, "Beta": 0.25, "Charlie": 0.25, "Delta": 0.25}}

func _ready():
	
	train_hmm(observations)
	

# Define a function to train the HMM given a sequence of observations
func train_hmm(observations):
		# Initialize the forward and backward probabilities
	var forward_prob = []
	var backward_prob = []
	for i in range(observations.size()):
		forward_prob.append({})
		backward_prob.append({})
		# Initialize the initial forward probability
	for state in states:
		forward_prob[0][state] = initial_prob[state] * emission_prob[state][observations[0]]
		# Compute the forward probabilities for the rest of the sequence
	for t in range(1, observations.size()):
		for state in states:
			forward_prob[t][state] = 0
			for prev_state in states:
				forward_prob[t][state] += forward_prob[t-1][prev_state] * transition_prob[prev_state][state]
				forward_prob[t][state] *= emission_prob[state][observations[t]]
		# Initialize the initial backward probability
	for state in states:
		backward_prob[-1][state] = 1
		# Compute the backward probabilities for the rest of the sequence
	for t in range(observations.size()-2, -1, -1):
		for state in states:
			backward_prob[t][state] = 0
			for next_state in states:
				backward_prob[t][state] += backward_prob[t+1][next_state] * transition_prob[state][next_state] * emission_prob[next_state][observations[t+1]]
		# Compute the state and transition probabilities for each time step
	var state_prob = []
	var transition_prob_per_timestep = []
	for t in range(observations.size()):
		state_prob.append({})
		transition_prob_per_timestep.append({})
		var total_prob = 0
		for state in states:
			state_prob[t][state] = forward_prob[t][state] * backward_prob[t][state]
			total_prob += state_prob[t][state]
		for state in states:
			state_prob[t][state] /= total_prob
			if t < observations.size() - 1:
				transition_prob_per_timestep[t][state] = {}
				var total_transition_prob = 0
				for next_state in states:
					transition_prob_per_timestep[t][state][next_state] = forward_prob[t][state] * transition_prob[state][next_state] * emission_prob[next_state][observations[t+1]] * backward_prob[t+1][next_state]
					total_transition_prob += transition_prob_per_timestep[t][state][next_state]
				for next_state in states:
					transition_prob_per_timestep[t][state][next_state] /= total_transition_prob
		# Update the model parameters with the computed probabilitiy
	for state in states:
		initial_prob[state] = state_prob
	
	print(forward_prob)
	print(initial_prob)

func set_color_labels(color: String, index) -> void:
	
	info_label.text = "Showing transition probabilities for the color " + color + ":"
	
	red_forward_label.text = "Forward: " + str(transition_prob[color]["Red"])
	red_backward_label.text = "Backward: " + str(initial_prob[color][index]["Red"])
	blue_forward_label.text = "Forward: " + str(transition_prob[color]["Blue"])
	blue_backward_label.text = "Backward: " + str(initial_prob[color][index]["Blue"])
	green_forward_label.text = "Forward: " + str(transition_prob[color]["Green"])
	green_backward_label.text = "Backward: " + str(initial_prob[color][index]["Green"])
	yellow_forward_label.text = "Forward: " + str(transition_prob[color]["Yellow"])
	yellow_backward_label.text = "Backward: " + str(initial_prob[color][index]["Yellow"])
	

func _on_Red_mouse_entered():
	
	set_color_labels("Red", 2)
	


func _on_Blue_mouse_entered():
	
	set_color_labels("Blue", 0)
	


func _on_Green_mouse_entered():
	
	set_color_labels("Green", 1)
	


func _on_Yellow_mouse_entered():
	
	set_color_labels("Yellow", 3)
	
