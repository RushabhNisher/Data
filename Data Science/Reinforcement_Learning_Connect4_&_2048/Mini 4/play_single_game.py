from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from keras.models import load_model
from gamelogic.game import Game, ACTION_NAMES
import os
import tensorflow as tf
import numpy as np

path = os.getcwd()


def play_single_game():
    """Play a single game using the latest model snapshot"""
    game = Game()
    state_size = 16
    debug = True



    model = load_model(path + "/data/checkpoint")
  
    game.new_game()
    state = game.state()
    state = np.reshape(state, [1, state_size])
    while not game.game_over():
        # get action from highest q-value
        act_values = model.predict(state)
        if len(game.available_actions())< 4:
          temp = game.available_actions()
          for i in range(0, 4):
            if i not in temp:
              act_values[0][i] = -100
        #returns action with highest q-value
        action = np.argmax(act_values[0])
        
        reward = (game.do_action(action))**2
        next_state = game.state()
        actions_available = game.available_actions()
        if len(actions_available) == 0: 
            done = True
        else:
            done = False
        next_state = np.reshape(next_state, [1, state_size])
        state = next_state
        print("Action:", ACTION_NAMES[action])
        print("Reward:", reward)
        game.print_state()

        if done:
            states = game.state()
            states = np.reshape(state, [1, state_size])
            max_value = np.amax(states[0])
            print("Score:", game.score())
            print("Max Value: " + str(2**max_value))
            print("Game over.")
            break
        


if __name__ == "__main__":
  """Main function."""
  play_single_game()