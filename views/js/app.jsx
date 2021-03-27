class App extends React.Component {
    render(){
            return (<Words />)
    }
}


class Words extends React.Component{
    constructor(props){
        super(props);
        this.state = {
           word:'',
           result: [],
        }
    }

    onSubmit = event => {
        event.preventDefault();
        const inp = this.input.value;
        console.log(inp)
        fetch(`/api/words?value=${encodeURIComponent(inp)}`,{
            "method":"GET",
        })
        .then(response => {return response.json()})
        .then((data) => {
            console.log("hello")
            console.log(data);
            this.setState({result: data});
        })
        .catch(err => {
            console.log(err)
        });
    }

    render() {
        return (
        <div className="container">
                <div className="col-xs-8 col-xs-offset-2 jumbotron text-center" >
                    <h2>Urban Dictionary</h2>

                    <form onSubmit={this.onSubmit}>

                        <label htmlFor="word">Word</label>
                        <input
                            type="text"
                            name="word"
                            defaultValue="hell"
                            ref={input => this.input = input}
                        />
                        <button 
                            type="submit" 
                            className="btn btn-primary"
                            >Get
                            
                        </button>
                    </form>
                    <p><h2># {this.state.result["word"]}</h2></p>
                    <p> <b>Definition : </b>{this.state.result["definition"]}</p>
                </div>
          </div>
        )
    }

    handleChange = ({target}) => {
        this.setState( {[target.name] : target.value})
    };

}


ReactDOM.render(<App />, document.getElementById('app'));