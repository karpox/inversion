Plan = require('../models/planModel');


exports.index = (async (req, res) => {
    const planes = await Plan.find();
    res.json({planes});
});

exports.new = (async (req, res) =>{
    
    await Plan.create({
        name:  req.body.name,
        invmin: req.body.invmin,
        invmax: req.body.invmax,
        tasa: req.body.tasa,
        duracion: req.body.duracion
    });
    
    res.json({message: 'Creado'});
})

exports.view = function(req, res) {
    Plan.findById(req.params.id, function(err, plan) {
        if (err) {
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        }
        res.json({
            status: 'success',
            code: 200,
            message: 'Registros encontrado',
            data: plan
        })
    })
}


exports.delete = function(req, res) {
    Plan.deleteOne({
        _id: req.params.id
    }, function(err) {
        if (err)
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
        res.json({
            status: 'success',
            code: 200,
            message: 'Registros eliminado'
        })
    })
}

exports.update = function(req, res) {
    Plan.findById(req.params.id, function(err, plan) {
        if (err)
            res.json({
                status: 'err',
                code: 500,
                message: err
            })
            plan.name =  req.body.name,
            plan.invmin = req.body.invmin,
            plan.invmax = req.body.invmax,
            plan.tasa = req.body.tasa,
            plan.duracion = req.body.duracion
        plan.save(function(err) {
            if (err)
                res.json({
                    status: 'err',
                    code: 500,
                    message: err
                })
            res.json({
                status: 'success',
                code: 200,
                message: 'Registro actualizado',
                data: plan
            })
        })
    })
}