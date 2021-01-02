"""Game class to represent 2048 game state."""

import numpy as np

ACTION_NAMES = ["left", "up", "right", "down"]
ACTION_LEFT = 0
ACTION_UP = 1
ACTION_RIGHT = 2
ACTION_DOWN = 3

class Game(object):
  """Represents a 2048 Game state and implements the actions.

  Implements the 2048 Game logic, as specified by this source file:
  https://github.com/gabrielecirulli/2048/blob/master/js/game_manager.js

  Game states are represented as shape (4, 4) numpy arrays whos entries are 0
  for empty fields and ln2(value) for any tiles.
  """

  def __init__(self, state=None, initial_score=0):
    """Init the Game object.

    Args:
      state: Shape (4, 4) numpy array to initialize the state with. If None,
          the state will be initialized with with two random tiles (as done
          in the original gamelogic).
      initial_score: Score to initialize the Game with.
    """

    self._score = initial_score

    if state is None:
      self._state = np.zeros((4, 4), dtype=np.int)
      self.add_random_tile()
      self.add_random_tile()
    else:
      self._state = state

  def new_game(self, initial_score=0):
      self._score = initial_score
      self._state = np.zeros((4, 4), dtype=np.int)
      self.add_random_tile()
      self.add_random_tile()

  def copy(self):
    """Return a copy of self."""

    return Game(np.copy(self._state), self._score)

  def game_over(self):
    """Whether the gamelogic is over."""

    for action in range(4):
      if self.is_action_available(action):
        return False
    return True

  def available_actions(self):
    """Computes the set of actions that are available."""
    return [action for action in range(4) if self.is_action_available(action)]

  def is_action_available(self, action):
    """Determines whether action is available.
    That is, executing it would change the state.
    """

    temp_state = np.rot90(self._state, action)
    return self._is_action_available_left(temp_state)

  def _is_action_available_left(self, state):
    """Determines whether action 'Left' is available."""

    # True if any field is 0 (empty) on the left of a tile or two tiles can
    # be merged.
    for row in range(4):
      has_empty = False
      for col in range(4):
        has_empty |= state[row, col] == 0
        if state[row, col] != 0 and has_empty:
          return True
        if (state[row, col] != 0 and col > 0 and
            state[row, col] == state[row, col - 1]):
          return True

    return False


  def do_action(self, action):
    """Execute action, add a new tile, update the score & return the reward."""

    temp_state = np.rot90(self._state, action)
    reward = self._do_action_left(temp_state)
    self._state = np.rot90(temp_state, -action)
    self._score += reward

    self.add_random_tile()

    return reward

  def _do_action_left(self, state):
    """Exectures action 'Left'."""

    reward = 0

    for row in range(4):
      # Always the rightmost tile in the current row that was already moved
      merge_candidate = -1
      merged = np.zeros((4,), dtype=np.bool)

      for col in range(4):
        if state[row, col] == 0:
          continue

        if (merge_candidate != -1 and
            not merged[merge_candidate] and
            state[row, merge_candidate] == state[row, col]):
          # Merge tile with merge_candidate
          state[row, col] = 0
          merged[merge_candidate] = True
          state[row, merge_candidate] += 1
          reward += (2 ** state[row, merge_candidate])

        else:
          # Move tile to the left
          merge_candidate += 1
          if col != merge_candidate:
            state[row, merge_candidate] = state[row, col]
            state[row, col] = 0

    return reward

  def add_random_tile(self):
    """Adds a random tile to the grid. Assumes that it has empty fields."""

    x_pos, y_pos = np.where(self._state == 0)
    assert len(x_pos) != 0
    empty_index = np.random.choice(len(x_pos))
    value = np.random.choice([1, 2], p=[0.9, 0.1])

    self._state[x_pos[empty_index], y_pos[empty_index]] = value

  def print_state(self):
    """Prints the current state."""

    def tile_string(value):
      """Concert value to string."""
      if value > 0:
        return '% 5d' % (2 ** value,)
      return "     "

    print("-" * 25)
    for row in range(4):
      print("|" + "|".join([tile_string(v) for v in self._state[row, :]]) + "|")
      print("-" * 25)

  def state(self):
    """Return current state."""
    return self._state

  def score(self):
    """Return current score."""
    return self._score
