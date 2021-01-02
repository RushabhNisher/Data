# -*- coding: utf-8 -*-
import numpy as np
import random
from collections import deque
from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import Adam
import json
from gamelogic.game import Game
import time
from shutil import copyfile
import parameters
import os

EPISODES = 100000

path  = os.getcwd()

class DQNAgent:
    def __init__(self):
        self.state_size = 16
        self.action_size = 4 # (up, down, right, left)
        self.memory = deque(maxlen=5000000)
        self.gamma = parameters.gamma    # discount rate
        self.epsilon = 1.0  # exploration rate
        self.epsilon_min = 0.01
        self.epsilon_decay = parameters.epsilon_decay
        self.learning_rate = parameters.learning_rate
        self.model = self._build_model()
        self.batch_size = parameters.batch_size
        self.is_max_value_reward = parameters.is_max_value_reward
        self.max_value_reward_threshold = parameters.max_value_reward_threshold
        self.max_value_reward_amount = parameters.max_value_reward_amount
        self.output_name = parameters.output_name
        filename = path + "/data/"
        if not os.path.exists(filename):
            os.makedirs(filename)

    def _build_model(self):
        # Neural Net for Deep-Q learning Model
        model = Sequential()
        model.add(Dense(24, input_dim=self.state_size, activation='relu'))
        model.add(Dense(256, activation='relu'))
        model.add(Dense(256, activation='relu'))
        model.add(Dense(self.action_size, activation='relu'))
        model.compile(loss='mse',
                      optimizer=Adam(lr=self.learning_rate))
        return model

    def remember(self, state, action, reward, next_state, done):
        """algorithm tends to forget the previous experiences as it overwrites them with new experiences.
        Therefore we re-train the model with previous experiences."""
        self.memory.append((state, action, reward, next_state, done))

    def act(self, state):
        if np.random.rand() <= self.epsilon:
            return random.choice(game.available_actions())
        #forward feeding
        act_values = self.model.predict(state)
        #sets q-values of not available actions to -100 so they are not chosen
        if len(game.available_actions())< 4:
          temp = game.available_actions()
          for i in range(0, 4):
            if i not in temp:
              act_values[0][i] = -100
        #returns action with highest q-value
        return np.argmax(act_values[0])
        #replace return with this for a random agent:
        #return random.choice(game.available_actions())

    def replay(self, batch_size):
        """trains the neural net with experiences from memory (minibatches)"""
        #samples mimibatch from memory
        minibatch = random.sample(self.memory, batch_size)
        #for each memory
        for state, action, reward, next_state, done in minibatch:
            #if its final state set target to the reward
            target = reward
            if not done:
                #set target according to formula
                target = (reward + self.gamma * np.amax(self.model.predict(next_state)[0]))
            #gets all 4 predictions from current state
            target_f = self.model.predict(state)
            #takes the one action which was selected in batch
            target_f[0][action] = target
            #trains the model
            self.model.fit(state, target_f, epochs=1, verbose=0)
        if self.epsilon > self.epsilon_min:
            self.epsilon *= self.epsilon_decay

    def load(self, name):
        self.model.load_weights(name)

    def save(self, name):
        self.model.save(name)



if __name__ == "__main__":
    game = Game()
    agent = DQNAgent()
    # agent.load("./save/file")
    done = False
    batch_size = agent.batch_size
    debug = False
    save_maxvalues = True
    output_list = []


    for e in range(EPISODES):
        game.new_game()
        state = game.state()
        state = np.reshape(state, [1, agent.state_size])
        while not game.game_over():
            action = agent.act(state)
            reward = (game.do_action(action))**2
            if(agent.is_max_value_reward):
                reward = 0
                temp = game.state()
                temp_reshaped = np.reshape(temp, [1, agent.state_size])
                temp_max_value = np.amax(temp_reshaped[0])
                if temp_max_value > agent.max_value_reward_threshold:
                    reward = agent.max_value_reward_amount
            next_state = game.state()
            actions_available = game.available_actions()
            if len(actions_available) == 0:
                done = True
            else:
                done = False
            next_state = np.reshape(next_state, [1, agent.state_size])
            agent.remember(state, action, reward, next_state, done)
            state = next_state

            if done:
                if (debug): print("no action available")
                states = game.state()
                states = np.reshape(state, [1, agent.state_size])
                max_value = np.amax(states[0])
                output_list.append([e, np.asscalar(max_value), np.asscalar(game.score()), agent.epsilon])
                if(debug):print("max_value: " + str(max_value))
                break
        print("episodes: " + str(e))

        #save copy of configuration and the episode_maxvalue_data
        if save_maxvalues:
            if e == 100:
                output_list.insert(0, "gamma: "+str(parameters.gamma)+" | epsilon decay: "+str(parameters.epsilon_decay)+" | learning rate: "+str(parameters.learning_rate)+"\n batch size: "+str(parameters.batch_size)+" | reward = maxVal: "+str(parameters.is_max_value_reward)+" | reward amount: "+str(parameters.max_value_reward_amount)+" | reward threshold: "+str(parameters.max_value_reward_threshold))
            if e % 100 == 0:
                with open(path + "/data/"+agent.output_name+"output.txt", "w") as outfile:
                    json.dump(output_list, outfile)

        if len(agent.memory) > batch_size:
            agent.replay(batch_size)
        if e % 1000 == 0:
            timenow = time.strftime("%Y-%m-%d_%H-%M-%S")
            savepath = path + "/data/checkpoint"
            agent.save(savepath)
