from pylab import *
import networkx as nx


def FA1(x) :
  return sqrt(1-(x-3)**2)*0.08

def FA2(x) :
  return sqrt(2.5**2-(x-1.5)**2)*0.07 +.5

def FA3(x) :
  return -sqrt(2.5**2-(x-3.5)**2)*0.05 +.5

def FB1(x) :
  return sqrt(1-(x-2)**2)*0.05

def FB2(x) :
  return -sqrt(1-(x-3)**2)*0.08

def FB3(x) :
  return -sqrt(1.5**2-(x-0.5)**2)*0.05 +.5 

def FB4(x) :
  return sqrt(2.5**2-(x-3.5)**2)*0.07 +.5

def FB5(x) :
  return -sqrt(2**2-(x-5)**2)*0.04 +.5


def nodos(top,label) :
  
  G = nx.Graph()
  
  #A
  G.add_node(0,pos=(0,0),color='0.8')
  G.add_node(1,pos=(1,0),color='0.8')
  G.add_node(2,pos=(2,0),color='0.8')
  G.add_node(3,pos=(3,0),color='0.8')
  G.add_node(4,pos=(4,0),color='0.8')
  G.add_node(5,pos=(5,0),color='0.8')
  
  #B
  G.add_node(6,pos=(-2,0.5),color='0.4')
  G.add_node(7,pos=(-1,0.5),color='0.4')
  G.add_node(8,pos=(0,0.5),color='0.4')
  G.add_node(9,pos=(1,0.5),color='0.4')
  G.add_node(10,pos=(2,0.5),color='0.4')
  G.add_node(11,pos=(3,0.5),color='0.4')
  G.add_node(12,pos=(4,0.5),color='0.4')
  G.add_node(13,pos=(5,0.5),color='0.4')
  G.add_node(14,pos=(6,0.5),color='0.4')
  G.add_node(15,pos=(7,0.5),color='0.4')
  
  #
  G.add_node(16,pos=(2.5,-0.5),color='white')
  
  
  for i in range(5) :
    G.add_edge(i,i+1,weight=4)
    
  for j in range(6,15) :
    G.add_edge(j,j+1,weight=4)
      
  G.add_edge(2,16,weight=1)
  
  for k in top :
    G.add_edge(k[0],k[1],weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)
    
    
def nodosAC(top,label) :
  
  G = nx.Graph()
  
  #A
  G.add_node(0,pos=(0,0),color='0.8')
  G.add_node(1,pos=(1,0),color='0.8')
  G.add_node(2,pos=(2,0),color='0.8')
  G.add_node(3,pos=(3,0),color='0.8')
  G.add_node(4,pos=(4,0),color='0.8')
  G.add_node(5,pos=(5,0),color='0.8')
  
  #B
  G.add_node(6,pos=(-2,0.5),color='0.4')
  G.add_node(7,pos=(-1,0.5),color='0.4')
  G.add_node(8,pos=(0,0.5),color='0.4')
  G.add_node(9,pos=(1,0.5),color='0.4')
  G.add_node(10,pos=(2,0.5),color='0.4')
  G.add_node(11,pos=(3,0.5),color='0.4')
  G.add_node(12,pos=(4,0.5),color='0.4')
  G.add_node(13,pos=(5,0.5),color='0.4')
  G.add_node(14,pos=(6,0.5),color='0.4')
  G.add_node(15,pos=(7,0.5),color='0.4')
  
  #
  G.add_node(16,pos=(2.5,-0.5),color='white')
  
  
  for i in range(5) :
    G.add_edge(i,i+1,weight=4)
    
  for j in range(6,15) :
    G.add_edge(j,j+1,weight=4)
      

  G.add_edge(2,10,weight=1)
  
  for k in top :
    G.add_edge(k[0],k[1],weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)
    

def nodosABC(top,label) :
  
  G = nx.Graph()
  
  #A
  G.add_node(0,pos=(0,0),color='0.8')
  G.add_node(1,pos=(1,0),color='0.8')
  G.add_node(2,pos=(2,0),color='0.8')
  G.add_node(3,pos=(3,0),color='0.8')
  G.add_node(4,pos=(4,0),color='0.8')
  G.add_node(5,pos=(5,0),color='0.8')
  
  #B
  G.add_node(6,pos=(-2,0.5),color='0.4')
  G.add_node(7,pos=(-1,0.5),color='0.4')
  G.add_node(8,pos=(0,0.5),color='0.4')
  G.add_node(9,pos=(1,0.5),color='0.4')
  G.add_node(10,pos=(2,0.5),color='0.4')
  G.add_node(11,pos=(3,0.5),color='0.4')
  G.add_node(12,pos=(4,0.5),color='0.4')
  G.add_node(13,pos=(5,0.5),color='0.4')
  G.add_node(14,pos=(6,0.5),color='0.4')
  G.add_node(15,pos=(7,0.5),color='0.4')
  
  #C
  G.add_node(16,pos=(2.5,-0.5),color='white')
  
  
  for i in range(5) :
    G.add_edge(i,i+1,weight=4)
    
  for j in range(6,15) :
    G.add_edge(j,j+1,weight=4)
      
  
  for k in top :
    G.add_edge(k[0],k[1],weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)
    
    
    
def nodos1(label) :
  
  G = nx.Graph()
  
  #A
  G.add_node(0,pos=(0,0),color='0.8')
  G.add_node(1,pos=(1,0),color='0.8')
  G.add_node(2,pos=(2,0),color='0.8')
  G.add_node(3,pos=(3,0),color='0.8')
  G.add_node(4,pos=(4,0),color='0.8')
  G.add_node(5,pos=(5,0),color='0.8')
  
  #B
  G.add_node(6,pos=(-2,0.5),color='0.4')
  G.add_node(7,pos=(-1,0.5),color='0.4')
  G.add_node(8,pos=(0,0.5),color='0.4')
  G.add_node(9,pos=(1,0.5),color='0.4')
  G.add_node(10,pos=(2,0.5),color='0.4')
  G.add_node(11,pos=(3,0.5),color='0.4')
  G.add_node(12,pos=(4,0.5),color='0.4')
  G.add_node(13,pos=(5,0.5),color='0.4')
  G.add_node(14,pos=(6,0.5),color='0.4')
  G.add_node(15,pos=(7,0.5),color='0.4')
  
  #
  G.add_node(16,pos=(2.5,-0.5),color='white')
  
  
  for i in range(5) :
    G.add_edge(i,i+1,weight=4)
    
  for j in range(6,15) :
    G.add_edge(j,j+1,weight=4)
      
  G.add_edge(0,16,weight=1)
  
  
  G.add_edge(2,10,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,'k'+label,markersize=10) 
  

def nodos2(label) :

  xs1=linspace(2,4)
  plot(xs1,FA1(xs1),'k',linewidth=4)
  xs2=linspace(-1,4)
  plot(xs2,FA2(xs2),'k',linewidth=4)
  xs3=linspace(1,6)
  plot(xs3,FA3(xs3),'k',linewidth=4)
  
  G = nx.Graph()
 
  #A
  G.add_node(0,pos=(0,0),color='0.8')
  G.add_node(1,pos=(1,0),color='0.8')
  G.add_node(2,pos=(2,0),color='0.8')
  G.add_node(3,pos=(3,0),color='0.8')
  G.add_node(4,pos=(4,0),color='0.8')
  G.add_node(5,pos=(5,0),color='0.8')
  
  #B
  G.add_node(6,pos=(-2,0.5),color='0.4')
  G.add_node(7,pos=(-1,0.5),color='0.4')
  G.add_node(8,pos=(0,0.5),color='0.4')
  G.add_node(9,pos=(1,0.5),color='0.4')
  G.add_node(10,pos=(2,0.5),color='0.4')
  G.add_node(11,pos=(3,0.5),color='0.4')
  G.add_node(12,pos=(4,0.5),color='0.4')
  G.add_node(13,pos=(5,0.5),color='0.4')
  G.add_node(14,pos=(6,0.5),color='0.4')
  G.add_node(15,pos=(7,0.5),color='0.4')
  
  #
  G.add_node(16,pos=(2.5,-0.5),color='white')
  
  
  for i in range(5) :
    G.add_edge(i,i+1,weight=4)
    
  for j in range(6,15) :
    G.add_edge(j,j+1,weight=4)
      
  G.add_edge(0,16,weight=1)
  
  
  G.add_edge(5,6,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
 
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,'k'+label,markersize=10)   
  
  
  
def nodos3(label) :

  xs1=linspace(1,3)
  plot(xs1,FB1(xs1),'k',linewidth=4)
  xs2=linspace(2,4)
  plot(xs2,FB2(xs2),'k',linewidth=4)
  xs3=linspace(-1,2)
  plot(xs3,FB3(xs3),'k',linewidth=4)
  xs4=linspace(1,6)
  plot(xs4,FB4(xs4),'k',linewidth=4)
  xs5=linspace(3,7)
  plot(xs5,FB5(xs5),'k',linewidth=4)
  
  G = nx.Graph()
 
  #A
  G.add_node(0,pos=(0,0),color='0.8')
  G.add_node(1,pos=(1,0),color='0.8')
  G.add_node(2,pos=(2,0),color='0.8')
  G.add_node(3,pos=(3,0),color='0.8')
  G.add_node(4,pos=(4,0),color='0.8')
  G.add_node(5,pos=(5,0),color='0.8')
  
  #B
  G.add_node(6,pos=(-2,0.5),color='0.4')
  G.add_node(7,pos=(-1,0.5),color='0.4')
  G.add_node(8,pos=(0,0.5),color='0.4')
  G.add_node(9,pos=(1,0.5),color='0.4')
  G.add_node(10,pos=(2,0.5),color='0.4')
  G.add_node(11,pos=(3,0.5),color='0.4')
  G.add_node(12,pos=(4,0.5),color='0.4')
  G.add_node(13,pos=(5,0.5),color='0.4')
  G.add_node(14,pos=(6,0.5),color='0.4')
  G.add_node(15,pos=(7,0.5),color='0.4')
  
  #
  G.add_node(16,pos=(2.5,-0.5),color='white')
  
  
  for i in range(5) :
    G.add_edge(i,i+1,weight=4)
    
  for j in range(6,15) :
    G.add_edge(j,j+1,weight=4)
      
  G.add_edge(0,16,weight=1)
  
  
  G.add_edge(5,6,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
 
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,'k'+label,markersize=10)   
  