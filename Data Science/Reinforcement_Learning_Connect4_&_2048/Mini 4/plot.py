import json
import matplotlib.pyplot as plt
import os
#plotting info from https://matplotlib.org/gallery/ticks_and_spines/multiple_yaxis_with_spines.html


#####SET PARAMETERS HERE######
stepsize = 100
plot_max_instead_of_avg = False
inputname = "test"
debug = False
#####SET PARAMETERS HERE######

path = os.getcwd()

def plot():
    with open(path + '/data/'+inputname+'output.txt', "r") as infile:
      inputlist = json.load(infile)
      if (debug): print("path is: " + str(path))
      if (debug): print("list is: " + str(inputlist))
      #extract first item from list which is the configuration info

      plottitle = inputlist[0]
      inputlist.pop(0)
      calculate_data(inputlist, plottitle)



def calculate_data(inputlist, plottitle):
  number_of_steps = int(len(inputlist) / stepsize)
  if(debug):print("nr of steps is: " + str(number_of_steps))

  # EPISODES
  episodes_list = []
  for i in range(1, number_of_steps + 1):
    episodes_list.append(i * stepsize);
  if (debug):print("episode list: " + str(episodes_list))

  # Average Score
  avg_score_list = []
  for i in range(0, number_of_steps):
    sum = 0
    for j in range(0, stepsize):
      sum = sum + inputlist[stepsize * i + j][2]
    result = sum / (stepsize)
    avg_score_list.append(result)
  if (debug):print("avg_score_list: " + str(avg_score_list))

  # Average MaxValue
  avg_max_value_list = []
  for i in range(0, number_of_steps):
    sum = 0
    for j in range(0, stepsize):
      sum = sum + inputlist[stepsize * i + j][1]
    result = sum / float(stepsize)
    avg_max_value_list.append(result)
  if (debug):print("avg_max_value_list: " + str(avg_max_value_list))

  # Epsilon
  epsilon_list = []
  for i in range(0, number_of_steps):
    result = inputlist[stepsize * i][3]
    epsilon_list.append(result)
  if (debug):print("epsilon_list: " + str(epsilon_list))

  # MaxScore
  max_score_list = []
  # make now list consisting only of scores
  templist = [i[2] for i in inputlist]
  for i in range(0, number_of_steps):
    result = max(templist[i * stepsize:((i + 1) * stepsize)])
    max_score_list.append(result)
  if (debug):print("max_score: " + str(max_score_list))

  # MaxValue
  max_value_list = []
  # make now list consisting only of scores
  templist_two = [i[1] for i in inputlist]
  for i in range(0, number_of_steps):
    result = max(templist_two[i * stepsize:((i + 1) * stepsize)])
    max_value_list.append(result)
  if (debug):print("max_value_list: " + str(max_value_list))


  if(plot_max_instead_of_avg):
      plot_data(plottitle, max_x=len(inputlist)-(len(inputlist)%stepsize), para_episodes_list=episodes_list, para_value_list=max_value_list, para_score_list=max_score_list, para_epsilon_list=epsilon_list)
  else:
      plot_data(plottitle, max_x=len(inputlist)-(len(inputlist)%stepsize), para_episodes_list=episodes_list, para_value_list=avg_max_value_list, para_score_list=avg_score_list, para_epsilon_list=epsilon_list)


def plot_data(plottitle, max_x, para_episodes_list, para_value_list, para_score_list, para_epsilon_list):
    def make_patch_spines_invisible(ax):
        ax.set_frame_on(True)
        ax.patch.set_visible(False)
        for sp in ax.spines.values():
            sp.set_visible(False)


    fig, host = plt.subplots()
    fig.subplots_adjust(right=0.75)
    par1 = host.twinx()
    par2 = host.twinx()
    par2.spines["right"].set_position(("axes", 1.2))
    make_patch_spines_invisible(par2)
    par2.spines["right"].set_visible(True)

    #Score
    p1, = host.plot(para_episodes_list, para_score_list, "b-", label="Score")
    #MaxValue
    p2, = par1.plot(para_episodes_list, para_value_list, "r-", label="MaxValue")
    #Epsilon
    p3, = par2.plot(para_episodes_list, para_epsilon_list, "g-", label="Epsilon")

    #Episodes
    host.set_xlim(stepsize, max_x)
    #Score
    #host.set_ylim(0, 9000)
    host.set_ylim(0, 2500)
    if (plot_max_instead_of_avg): host.set_ylim(0, 9000)
    #MaxValue
    par1.set_ylim(6, 8)
    if (plot_max_instead_of_avg): par1.set_ylim(6, 11)
    #Epsilon
    par2.set_ylim(0, 1)


    host.set_xlabel("Episodes")
    host.set_ylabel("Score")
    par1.set_ylabel("Max_Value")
    par2.set_ylabel("Epsilon")
    host.yaxis.label.set_color(p1.get_color())
    par1.yaxis.label.set_color(p2.get_color())
    par2.yaxis.label.set_color(p3.get_color())
    tkw = dict(size=4, width=1.5)
    host.tick_params(axis='y', colors=p1.get_color(), **tkw)
    par1.tick_params(axis='y', colors=p2.get_color(), **tkw)
    par2.tick_params(axis='y', colors=p3.get_color(), **tkw)
    host.tick_params(axis='x', **tkw)
    lines = [p1, p2, p3]
    host.legend(lines, [l.get_label() for l in lines])
    plt.title(plottitle, fontsize=10)
    additionalname = "_avg_"
    if (plot_max_instead_of_avg): additionalname = "_max_"

    figurepath = path + "/graphs/"
    if not os.path.exists(figurepath):
      os.makedirs(figurepath)
    fig.savefig(figurepath + str(inputname)+additionalname+"graph.pdf", bbox_inches='tight')
    plt.show()

plot()
