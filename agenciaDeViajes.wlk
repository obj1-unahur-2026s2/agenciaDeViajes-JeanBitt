class PackDeViajes {
  const duracion
  const property precioBase
  const property beneficiosEspeciales = []
  const coordinador

  method costoBeneficiosVigentes() {
    return beneficiosEspeciales
      .filter({ b => b.estaVigente() })
      .sum({ b => b.costo() })
  }

  method calcularPrecioFinal() {
    return precioBase + self.costoBeneficiosVigentes()
  }

  method esPremium()
}

class ViajesNacionales inherits PackDeViajes {
  const property provinciaDestino
  const property actividades

  override method esPremium() {
    return duracion > 10 && coordinador.esAltamenteCalificado()
  }
}

class ViajesInternacionales inherits PackDeViajes {
  const property paisDestino
  const property escalas
  const property esDeInteres

  override method calcularPrecioFinal() {
    return super() * 1.2
  }

  override method esPremium() {
    return duracion > 20 && escalas == 0 && esDeInteres
  }
}

class PacksProvinciales inherits ViajesNacionales {
  const property cantCiudadesAVisitar

  override method esPremium() {
    const cantidadBeneficiosVigentes =
      beneficiosEspeciales
        .filter({ b => b.estaVigente() })
        .size()

    return actividades.size() >= 4 &&
      cantCiudadesAVisitar > 5 &&
      cantidadBeneficiosVigentes >= 3
  }

  override method calcularPrecioFinal() {
    const precioNormal = super()
    return if (self.esPremium()) precioNormal * 1.05 else precioNormal
  }
}

class Coordinador {
  const property viajesRealizados
  const property aniosExperiencia
  const property motivado
  var property rol

  const rolesValidos = [guia, asistenteLogistico, acompañante]

  method cambiarRol(nuevoRol) {
    if (!rolesValidos.contains(nuevoRol)) {
      self.error("Rol no válido")
    } else {
      rol = nuevoRol
    }
  }

  method esAltamenteCalificado() {
    return viajesRealizados > 20 && rol.cumpleRequisitos(self)
  }
}

object guia {
  method cumpleRequisitos(unCoordinador) {
    return unCoordinador.motivado()
  }
}

object asistenteLogistico {
  method cumpleRequisitos(unCoordinador) {
    return unCoordinador.aniosExperiencia() >= 3
  }
}

object acompañante {
  method cumpleRequisitos(unCoordinador) {
    return true
  }
}

class BeneficioEspecial {
  const property tipoBeneficio
  const property costo
  const property estaVigente
}