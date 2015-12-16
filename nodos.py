from pylab import *
import networkx as nx


def topLine(x,a,b,h) :
  return sqrt(((b-a)/2.)**2-(x-(b+a-6)/2.)**2)*h/40 +.5


def bottomLine(x,a,b,h) :
  return sqrt(((b-a)/2.)**2-(x-(b+a-2)/2.)**2)*h/40


def topDraw(a,b,h) :
  x=linspace(a-3,b-3)
  plot(x,topLine(x,a,b,h),'k',linewidth=4)

def bottomDraw(a,b,h) :
  x=linspace(a-1,b-1)
  plot(x,bottomLine(x,a,b,h),'k',linewidth=4)  



################################################################

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
    
def nodosABC_lamb_gamma_labels(top,label) :
  
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
  
  text(2.5,.2,'$\gamma$',fontsize=15)
  text(2.5,-.3,'$\lambda$',fontsize=15)
  #plot(-3,-0.0,label,markersize=10)    
    
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
      
  G.add_edge(2,16,weight=1)
  
  
  G.add_edge(2,10,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10) 
  

def nodos2(label) :

  topDraw(2,6,-2)
  topDraw(4,9,-4)
  bottomDraw(4,6,-3)
  
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
  
  
  G.add_edge(2,10,weight=1)
  
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
 
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)   
  
  
  
def nodos3(label) :

  topDraw(1,3,-3)
  topDraw(4,7,-3)
  topDraw(2,9,-2)
  topDraw(7,10,-3)
  bottomDraw(2,4,-4)
  bottomDraw(3,6,-5)
  
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
  
  
  G.add_edge(2,10,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
 
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)   
  
  
  
def nodos4(label) :
  
  topDraw(2,5,-3)
  topDraw(5,9,-5)
  bottomDraw(3,5,-3)
  
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
  
  
  G.add_edge(2,10,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10) 
  

def nodos5(label) :
  
  topDraw(1,5,-5)
  topDraw(3,5,-3)
  topDraw(5,8,-3)
  topDraw(5,10,-4)
  bottomDraw(1,3,-3)
  bottomDraw(3,5,4)
  bottomDraw(3,6,-3)
  
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
  
  
  G.add_edge(2,10,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
 
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)   
  
  
  
def nodos6(label) :
  
  bottomDraw(1,3,-3)
  bottomDraw(1,5,-4)
  bottomDraw(1,6,3)
  
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
  
  
  G.add_edge(2,10,weight=1)
      
  weights = [G[u][v]['weight'] for u,v in G.edges()]
  ncolors = [G.node[x]['color'] for x in G.nodes()]
 
      
  pos=nx.get_node_attributes(G,'pos')
  nx.draw(G,pos, width=weights,node_color=ncolors,with_labels=False)
  
  #text(-3,-0.0,'$'+label+'$',fontsize=25)
  plot(-3,-0.0,label,markersize=10)     