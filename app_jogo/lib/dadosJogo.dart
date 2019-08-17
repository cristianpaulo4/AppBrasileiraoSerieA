
class dadosJogo{

  String _time;
  String _placar;
  String _data;
  String _hora;
  String _local;
  String _brasao;


  void setTime(String t1)=> this._time = t1;  
  void setPlacar(String p1)=> this._placar=p1; 
  void setData(String data)=> this._data=data;
  void setHora(String hora)=> this._hora=hora;
  void setLocal(String local)=> this._local=local;
  void setBrasao(String b1)=>this._brasao=b1;
  
  

  // get 
  String getTime()=>this._time;  
  String getPlacar()=>this._placar;  
  String getData()=>this._data;
  String getHora()=>this._hora;
  String getLocal()=>this._local;
  String getBrasao()=>this._brasao;

  

}